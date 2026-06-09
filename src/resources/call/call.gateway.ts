import { UseGuards, UsePipes } from '@nestjs/common';
import { ConfigService } from '@nestjs/config';
import {
  ConnectedSocket,
  MessageBody,
  OnGatewayDisconnect,
  SubscribeMessage,
  WebSocketGateway,
  WebSocketServer,
} from '@nestjs/websockets';
import { randomUUID } from 'crypto';
import { Server } from 'socket.io';
import { FriendStatus, MessageType } from '@prisma/client';
import { WsJwtGuard } from 'src/guards/ws-auth.guard';
import { WsJwtVerifyGuard } from 'src/guards/ws-jwt-verify.guard';
import { SocketWithUserAndDecodedAccessToken } from 'src/interfaces/interfaces.global';
import { PrismaService } from 'src/prisma/prisma.service';
import { ZodValidationPipe } from 'src/pipes/zod.pipe';
import { ChatService } from 'src/resources/chat/chat.service';
import { ChatGateway } from 'src/resources/chat/chat.gateway';
import {
  CallAnswerSchema,
  callAnswerSchema,
  CallIceSchema,
  callIceSchema,
  CallIdSchema,
  callIdSchema,
  CallOfferSchema,
  callOfferSchema,
  CallStartSchema,
  callStartSchema,
} from 'src/resources/call/call.schemas';

type CallType = 'audio' | 'video';

interface CallPeer {
  id: string;
  username: string;
  fullName: string;
  avatar: string | null;
}

interface CallSession {
  callId: string;
  roomId: string;
  callType: CallType;
  // The user who started the call - used as the author of the summary message.
  initiatorId: string;
  // Users who have joined and are actively negotiating/connected.
  participants: Set<string>;
  // Users invited but who haven't accepted/declined yet.
  invited: Set<string>;
  // Cached display info so we can tell peers who joined without re-querying.
  peers: Map<string, CallPeer>;
  // When a second participant first joined (call became "connected").
  connectedAt: number | null;
  // Whether anyone other than the initiator ever joined (missed vs answered).
  everConnected: boolean;
}

const userSelect = {
  id: true,
  username: true,
  fullName: true,
  avatar: true,
} as const;

// Mesh full-mesh topology gets expensive fast (each client holds N-1 peer
// connections and uploads its media N-1 times), so we hard-cap a session.
const MAX_PARTICIPANTS = 3;

/**
 * Group-capable (up to {@link MAX_PARTICIPANTS}) audio/video calling over a
 * full WebRTC mesh. The server is a signaling relay tied to chat rooms: it
 * tracks who is in a call session and relays SDP/ICE between peers. To avoid
 * offer "glare", only users already in the session send offers to a newcomer.
 */
@UseGuards(WsJwtGuard)
@WebSocketGateway({
  namespace: 'call',
  cors: { origin: '*' },
})
export class CallGateway implements OnGatewayDisconnect {
  @WebSocketServer()
  private server: Server;

  // userId -> set of socket ids (multi-tab/device safe).
  private userSockets: Map<string, Set<string>> = new Map();
  // callId -> session
  private sessions: Map<string, CallSession> = new Map();
  // userId -> callId they are currently part of (busy check, one call at a time).
  private userCall: Map<string, string> = new Map();

  constructor(
    private readonly prisma: PrismaService,
    private readonly configService: ConfigService,
    private readonly chatService: ChatService,
    private readonly chatGateway: ChatGateway,
  ) {}

  /**
   * Build the ICE server list from config. STUN is always present (free, no
   * hosting). TURN is added only when configured - drop the env vars in to make
   * calls reliable across strict NATs without touching any signaling code.
   */
  private getIceServers(): RTCIceServerLike[] {
    const stunUrls = (
      this.configService.get<string>('WEBRTC_STUN_URLS') ||
      'stun:stun.l.google.com:19302,stun:stun1.l.google.com:19302'
    )
      .split(',')
      .map((u) => u.trim())
      .filter(Boolean);

    const iceServers: RTCIceServerLike[] = [{ urls: stunUrls }];

    const turnUrls = this.configService.get<string>('WEBRTC_TURN_URLS');
    if (turnUrls) {
      iceServers.push({
        urls: turnUrls
          .split(',')
          .map((u) => u.trim())
          .filter(Boolean),
        username: this.configService.get<string>('WEBRTC_TURN_USERNAME'),
        credential: this.configService.get<string>('WEBRTC_TURN_CREDENTIAL'),
      });
    }

    return iceServers;
  }

  private registerSocket(userId: string, socketId: string) {
    const sockets = this.userSockets.get(userId);
    if (sockets) sockets.add(socketId);
    else this.userSockets.set(userId, new Set([socketId]));
  }

  private isUserOnline(userId: string): boolean {
    return (this.userSockets.get(userId)?.size ?? 0) > 0;
  }

  private emitToUser(userId: string, event: string, payload?: unknown) {
    this.server.to(`user:${userId}`).emit(event, payload);
  }

  private async isBlockedBetween(a: string, b: string): Promise<boolean> {
    const block = await this.prisma.friend.findFirst({
      where: {
        status: FriendStatus.BLOCKED,
        OR: [
          { userId: a, friendId: b },
          { userId: b, friendId: a },
        ],
      },
      select: { id: true },
    });
    return !!block;
  }

  /** Remove a user from a session and end the call if it's effectively over. */
  private removeFromSession(callId: string, userId: string) {
    const session = this.sessions.get(callId);
    if (!session) return;

    session.participants.delete(userId);
    session.invited.delete(userId);
    this.userCall.delete(userId);

    // Tell everyone still in the call that this peer left.
    session.participants.forEach((pid) =>
      this.emitToUser(pid, 'call:peer-left', { callId, userId }),
    );

    // The call is over when nobody active remains, or a lone participant is left
    // with no one else still ringing.
    const noneActive = session.participants.size === 0;
    const lonelyNoInvites =
      session.participants.size <= 1 && session.invited.size === 0;
    if (noneActive || lonelyNoInvites) {
      void this.finalizeSession(session);
    }
  }

  /**
   * End a session: notify whoever is left, write a "call summary" system message
   * into the chat room (missed vs answered + duration) and clear all state.
   */
  private async finalizeSession(session: CallSession) {
    if (!this.sessions.has(session.callId)) return;
    this.sessions.delete(session.callId);

    // Close out everyone (remaining participants + still-ringing invitees).
    [...session.participants, ...session.invited].forEach((uid) => {
      this.userCall.delete(uid);
      this.emitToUser(uid, 'call:ended', { callId: session.callId });
    });

    const status: 'missed' | 'ended' = session.everConnected
      ? 'ended'
      : 'missed';
    const duration =
      session.everConnected && session.connectedAt
        ? Math.max(0, Math.round((Date.now() - session.connectedAt) / 1000))
        : 0;

    const content = JSON.stringify({
      kind: 'call',
      callType: session.callType,
      status,
      duration,
    });

    try {
      const message = await this.chatService.handleCreateMessage(
        session.initiatorId,
        {
          roomId: session.roomId,
          content,
          type: MessageType.SYSTEM,
        },
      );
      await this.chatGateway.broadcastMessage(message, session.initiatorId);
    } catch {
      // A failed summary message must never crash call teardown.
    }
  }

  handleDisconnect(client: SocketWithUserAndDecodedAccessToken) {
    const userId = client.data?.user?.id as string | undefined;
    if (!userId) return;

    const sockets = this.userSockets.get(userId);
    if (sockets) {
      sockets.delete(client.id);
      if (sockets.size === 0) this.userSockets.delete(userId);
    }

    // Only drop from the call when the user has no remaining connections.
    if (!this.isUserOnline(userId)) {
      const callId = this.userCall.get(userId);
      if (callId) this.removeFromSession(callId, userId);
    }
  }

  /** Register the socket into the user's personal room and return ICE config. */
  @UseGuards(WsJwtVerifyGuard)
  @SubscribeMessage('call:subscribe')
  handleSubscribe(
    @ConnectedSocket() client: SocketWithUserAndDecodedAccessToken,
  ) {
    const userId = client.data.user.id;
    client.join(`user:${userId}`);
    this.registerSocket(userId, client.id);
    return { success: true, iceServers: this.getIceServers() };
  }

  @UseGuards(WsJwtVerifyGuard)
  @UsePipes(new ZodValidationPipe(callStartSchema))
  @SubscribeMessage('call:start')
  async handleStart(
    @ConnectedSocket() client: SocketWithUserAndDecodedAccessToken,
    @MessageBody() data: CallStartSchema,
  ) {
    const callerId = client.data.user.id;
    const { roomId, callType } = data;

    if (this.userCall.has(callerId)) {
      return { success: false, reason: 'busy' };
    }

    // The caller must belong to the room they're calling into.
    const myParticipant = await this.prisma.chatParticipant.findFirst({
      where: { userId: callerId, roomId, leftAt: null },
      select: { id: true },
    });
    if (!myParticipant) {
      client.emit('call:failed', { reason: 'not-a-member' });
      return { success: false, reason: 'not-a-member' };
    }

    const room = await this.prisma.chatRoom.findUnique({
      where: { id: roomId },
      select: {
        type: true,
        participants: {
          where: { leftAt: null },
          select: { user: { select: userSelect } },
        },
      },
    });
    if (!room) {
      client.emit('call:failed', { reason: 'no-room' });
      return { success: false, reason: 'no-room' };
    }

    const caller = room.participants.find((p) => p.user.id === callerId)?.user;
    const others = room.participants
      .map((p) => p.user)
      .filter((u) => u.id !== callerId);

    // Resolve who can actually be invited: online, not busy, not blocked.
    const invitees: CallPeer[] = [];
    for (const u of others) {
      if (invitees.length >= MAX_PARTICIPANTS - 1) break;
      if (!this.isUserOnline(u.id)) continue;
      if (this.userCall.has(u.id)) continue;
      if (await this.isBlockedBetween(callerId, u.id)) continue;
      invitees.push(u);
    }

    if (invitees.length === 0) {
      client.emit('call:unavailable', { roomId });
      return { success: false, reason: 'no-invitees' };
    }

    const callId = randomUUID();
    const session: CallSession = {
      callId,
      roomId,
      callType,
      initiatorId: callerId,
      participants: new Set([callerId]),
      invited: new Set(invitees.map((u) => u.id)),
      peers: new Map(),
      connectedAt: null,
      everConnected: false,
    };
    if (caller) session.peers.set(callerId, caller);
    invitees.forEach((u) => session.peers.set(u.id, u));

    this.sessions.set(callId, session);
    this.userCall.set(callerId, callId);

    invitees.forEach((u) => {
      this.emitToUser(u.id, 'call:incoming', {
        callId,
        roomId,
        callType,
        fromUser: caller,
      });
    });

    return {
      success: true,
      callId,
      iceServers: this.getIceServers(),
      // The caller starts alone; peers appear via `call:peer-joined`.
      participants: [] as CallPeer[],
    };
  }

  @UseGuards(WsJwtVerifyGuard)
  @UsePipes(new ZodValidationPipe(callIdSchema))
  @SubscribeMessage('call:accept')
  handleAccept(
    @ConnectedSocket() client: SocketWithUserAndDecodedAccessToken,
    @MessageBody() data: CallIdSchema,
  ) {
    const userId = client.data.user.id;
    const session = this.sessions.get(data.callId);

    if (!session || !session.invited.has(userId)) {
      client.emit('call:failed', { reason: 'expired' });
      return { success: false, reason: 'expired' };
    }

    if (session.participants.size >= MAX_PARTICIPANTS) {
      session.invited.delete(userId);
      client.emit('call:failed', { reason: 'full' });
      return { success: false, reason: 'full' };
    }

    // Snapshot existing participants BEFORE adding the newcomer - those are the
    // peers that will initiate offers towards them (glare-free negotiation).
    const existing = [...session.participants];

    session.invited.delete(userId);
    session.participants.add(userId);
    this.userCall.set(userId, session.callId);

    // First time someone other than the initiator joins -> the call is "live".
    if (!session.everConnected && session.participants.size >= 2) {
      session.everConnected = true;
      session.connectedAt = Date.now();
    }

    const newcomer = session.peers.get(userId);

    existing.forEach((pid) => {
      this.emitToUser(pid, 'call:peer-joined', {
        callId: session.callId,
        peer: newcomer,
      });
    });

    return {
      success: true,
      iceServers: this.getIceServers(),
      callType: session.callType,
      roomId: session.roomId,
      // Existing participants the newcomer should expect offers from.
      participants: existing
        .map((pid) => session.peers.get(pid))
        .filter((p): p is CallPeer => !!p),
    };
  }

  @UseGuards(WsJwtVerifyGuard)
  @UsePipes(new ZodValidationPipe(callIdSchema))
  @SubscribeMessage('call:reject')
  handleReject(
    @ConnectedSocket() client: SocketWithUserAndDecodedAccessToken,
    @MessageBody() data: CallIdSchema,
  ) {
    const userId = client.data.user.id;
    const session = this.sessions.get(data.callId);
    if (!session) return { success: true };

    session.invited.delete(userId);
    session.participants.forEach((pid) =>
      this.emitToUser(pid, 'call:invite-declined', {
        callId: data.callId,
        userId,
      }),
    );

    // If nobody accepted and only the lone caller remains, end the call.
    if (session.participants.size <= 1 && session.invited.size === 0) {
      void this.finalizeSession(session);
    }

    return { success: true };
  }

  @UseGuards(WsJwtVerifyGuard)
  @UsePipes(new ZodValidationPipe(callIdSchema))
  @SubscribeMessage('call:leave')
  handleLeave(
    @ConnectedSocket() client: SocketWithUserAndDecodedAccessToken,
    @MessageBody() data: CallIdSchema,
  ) {
    this.removeFromSession(data.callId, client.data.user.id);
    return { success: true };
  }

  @UseGuards(WsJwtVerifyGuard)
  @UsePipes(new ZodValidationPipe(callOfferSchema))
  @SubscribeMessage('call:offer')
  handleOffer(
    @ConnectedSocket() client: SocketWithUserAndDecodedAccessToken,
    @MessageBody() data: CallOfferSchema,
  ) {
    const fromUserId = client.data.user.id;
    const session = this.sessions.get(data.callId);
    this.emitToUser(data.toUserId, 'call:offer', {
      callId: data.callId,
      fromUser: session?.peers.get(fromUserId) ?? { id: fromUserId },
      offer: data.offer,
    });
    return { success: true };
  }

  @UseGuards(WsJwtVerifyGuard)
  @UsePipes(new ZodValidationPipe(callAnswerSchema))
  @SubscribeMessage('call:answer')
  handleAnswer(
    @ConnectedSocket() client: SocketWithUserAndDecodedAccessToken,
    @MessageBody() data: CallAnswerSchema,
  ) {
    const fromUserId = client.data.user.id;
    this.emitToUser(data.toUserId, 'call:answer', {
      callId: data.callId,
      fromUserId,
      answer: data.answer,
    });
    return { success: true };
  }

  @UseGuards(WsJwtVerifyGuard)
  @UsePipes(new ZodValidationPipe(callIceSchema))
  @SubscribeMessage('call:ice')
  handleIce(
    @ConnectedSocket() client: SocketWithUserAndDecodedAccessToken,
    @MessageBody() data: CallIceSchema,
  ) {
    const fromUserId = client.data.user.id;
    this.emitToUser(data.toUserId, 'call:ice', {
      callId: data.callId,
      fromUserId,
      candidate: data.candidate,
    });
    return { success: true };
  }
}

interface RTCIceServerLike {
  urls: string | string[];
  username?: string;
  credential?: string;
}
