import {
  WebSocketGateway,
  WebSocketServer,
  SubscribeMessage,
  OnGatewayConnection,
  OnGatewayDisconnect,
  ConnectedSocket,
  MessageBody,
} from '@nestjs/websockets';
import { Server, Socket } from 'socket.io';
import { UseGuards, UsePipes } from '@nestjs/common';
import { WsJwtAuthGuard } from '../../guards/ws-jwt-auth.guard';
import { ChatService } from './chat.service';
import { CreateMessageDto } from './dto/create-message.dto';
import { PrismaService } from 'src/prisma/prisma.service';
import { WsJwtGuard } from 'src/guards/ws-auth.guard';
import { SocketWithUserAndDecodedAccessToken } from 'src/interfaces/interfaces.global';
import { WsJwtVerifyGuard } from 'src/guards/ws-jwt-verify.guard';
import {
  JoinRoomSchema,
  joinRoomSchema,
  LeaveRoomSchema,
  leaveRoomSchema,
  sendMessageSchema,
} from 'src/resources/chat/schemas/chat.schemas';
import { ZodValidationPipe } from 'src/pipes/zod.pipe';
import { ChatMessageDataType } from 'src/libs/prisma-types';
import { PushService } from 'src/resources/push/push.service';

@UseGuards(WsJwtGuard)
@WebSocketGateway({
  cors: {
    origin: '*',
  },
  namespace: 'chat',
})
export class ChatGateway implements OnGatewayConnection, OnGatewayDisconnect {
  @WebSocketServer()
  server: Server;

  private typingUsers: Map<string, Set<string>> = new Map(); // roomId -> Set of userIds

  constructor(
    private readonly chatService: ChatService,
    private prisma: PrismaService,
    private readonly pushService: PushService,
  ) {}

  async handleConnection() {
    try {
      console.log('Connected');
    } catch (error) {
      console.log(error);
    }
  }

  handleDisconnect() {
    // Cleanup will be handled by the service
  }

  // Each user joins a personal room so they can receive message notifications
  // for any of their conversations, even when not viewing that room.
  @UseGuards(WsJwtVerifyGuard)
  @SubscribeMessage('chat:subscribe')
  async handleChatSubscribe(
    @ConnectedSocket() client: SocketWithUserAndDecodedAccessToken,
  ) {
    const userId = client.data.user.id;
    client.join(`user:${userId}`);
    return { success: true };
  }

  @UseGuards(WsJwtVerifyGuard)
  @UsePipes(new ZodValidationPipe(joinRoomSchema))
  @SubscribeMessage('joinRoom')
  async handleJoinRoom(
    @ConnectedSocket() client: SocketWithUserAndDecodedAccessToken,
    @MessageBody() data: JoinRoomSchema,
  ) {
    const userId = client.data.user.id;
    const { roomId } = data;
    const canJoin = await this.chatService.canUserJoinRoom(userId, roomId);
    console.log(canJoin);

    if (canJoin) {
      client.join(`room:${roomId}`);
      console.log('joined room', `room:${roomId}`);
      return { success: true };
    }
    return { success: false, message: 'Cannot join room' };
  }

  @UseGuards(WsJwtAuthGuard)
  @UsePipes(new ZodValidationPipe(leaveRoomSchema))
  @SubscribeMessage('leaveRoom')
  async handleLeaveRoom(
    @ConnectedSocket() client: SocketWithUserAndDecodedAccessToken,
    @MessageBody() data: LeaveRoomSchema,
  ) {
    const { roomId } = data;
    client.leave(`room:${roomId}`);
    // Remove from typing users
    this.removeTypingUser(roomId, client.data.user.id);
    return { success: true };
  }

  @UseGuards(WsJwtVerifyGuard)
  @UsePipes(new ZodValidationPipe(sendMessageSchema))
  @SubscribeMessage('sendMessage')
  async handleMessage(
    @ConnectedSocket() client: SocketWithUserAndDecodedAccessToken,
    @MessageBody() createMessageDto: CreateMessageDto,
  ) {
    const userId = client.data.user.id;
    const message = await this.chatService.handleCreateMessage(
      userId,
      createMessageDto,
    );

    await this.broadcastMessage(message, userId);

    return message;
  }

  /**
   * Broadcast a freshly created message to the room (live append) and to the
   * other participants' personal rooms (toast + unread badge). Shared by the
   * socket handler and the REST image-upload endpoint.
   */
  async broadcastMessage(message: ChatMessageDataType, senderId: string) {
    const roomId = message.room?.id;
    if (!roomId) return;

    this.server.to(`room:${roomId}`).emit('newMessage', message);

    const senderName =
      message.sender?.fullName || message.sender?.username || 'Someone';
    const preview = this.buildPushPreview(message);

    (message.room?.participants || []).forEach((participant) => {
      if (!participant.userId) return;

      // Notify every participant (including the sender) so their conversation
      // list (lastMessage, order) stays up-to-date even when they are not
      // currently viewing this room.
      this.server
        .to(`user:${participant.userId}`)
        .emit('chat:newMessageNotification', message);

      // Web Push only for OTHER participants who haven't muted the room.
      if (participant.userId !== senderId && !participant.isMuted) {
        void this.pushService
          .sendToUser(participant.userId, {
            title: senderName,
            body: preview,
            url: `/chat/${roomId}`,
            tag: `chat-${roomId}`,
          })
          .catch(() => undefined);
      }
    });
  }

  /** Short notification preview for a chat message of any type. */
  private buildPushPreview(message: ChatMessageDataType): string {
    switch (message.type) {
      case 'IMAGE':
        return 'Sent an image';
      case 'FILE':
        return 'Sent a file';
      case 'VOICE':
        return 'Sent a voice message';
      case 'POST_SHARE':
        return 'Shared a post';
      case 'SYSTEM': {
        try {
          const data = JSON.parse(message.content);
          if (data?.kind === 'call') {
            return data.status === 'missed' ? 'Missed call' : 'Call ended';
          }
        } catch {
          /* fall through to raw content */
        }
        return message.content;
      }
      default: {
        const text = message.content || '';
        return text.length > 120 ? `${text.slice(0, 117)}...` : text;
      }
    }
  }

  /**
   * Notify everyone in a room that a user has read its messages (read receipts).
   */
  emitMessagesRead(roomId: string, userId: string) {
    this.server.to(`room:${roomId}`).emit('messagesRead', { roomId, userId });
  }

  /**
   * Notify everyone in a room that a message's reactions changed.
   */
  emitMessageReactionUpdated(roomId: string, message: ChatMessageDataType) {
    this.server
      .to(`room:${roomId}`)
      .emit('chat:messageReactionUpdated', message);
  }

  /**
   * Notify the two users involved in a block/unblock that their relationship
   * changed, so each client can refresh the affected caches (chat composer
   * banner, profile, feeds) in real time instead of waiting for a reload.
   *
   * Reuses the per-user personal rooms (`user:<id>`) that clients join through
   * the global chat listener, so it reaches the target even when they are not
   * currently viewing the conversation.
   */
  emitRelationshipChanged(payload: {
    fromUserId: string;
    toUserId: string;
    isBlocked: boolean;
  }) {
    [payload.fromUserId, payload.toUserId].forEach((userId) => {
      this.server
        .to(`user:${userId}`)
        .emit('chat:relationshipChanged', payload);
    });
  }

  @UseGuards(WsJwtAuthGuard)
  @SubscribeMessage('approveMessage')
  async handleApproveMessage(
    @ConnectedSocket() client: Socket,
    @MessageBody() data: { messageId: string; roomId: string },
  ) {
    const userId = client.handshake.auth.userId;
    const room = await this.chatService.approveChatRoom({
      roomId: data.roomId,
      approverId: userId,
    });

    // Broadcast to room
    // this.server.to(`room:${data.roomId}`).emit('messageApproved', message);

    // Notify sender
    // this.server.to(`user:${message.senderId}`).emit('messageApproved', message);

    return room;
  }

  //   @UseGuards(WsJwtAuthGuard)
  //   @SubscribeMessage('rejectMessage')
  //   async handleRejectMessage(
  //     @ConnectedSocket() client: Socket,
  //     @MessageBody() data: { messageId: string; roomId: string },
  //   ) {
  //     const userId = client.handshake.auth.userId;
  //     const message = await this.chatService.rejectChatRoom({
  //       roomId: data.roomId,
  //       rejecterId: userId,
  //     });

  //     // Broadcast to room
  //     this.server.to(`room:${data.roomId}`).emit('messageRejected', message);

  //     // Notify sender
  //     this.server
  //       .to(`user:${message.data.}`)
  //       .emit('messageRejected', message);

  //     return message;
  //   }

  @UseGuards(WsJwtAuthGuard)
  @SubscribeMessage('typing')
  async handleTyping(
    @ConnectedSocket() client: Socket,
    @MessageBody() data: { roomId: string; isTyping: boolean },
  ) {
    const userId = client.handshake.auth.userId;

    if (data.isTyping) {
      this.addTypingUser(data.roomId, userId);
    } else {
      this.removeTypingUser(data.roomId, userId);
    }

    // Broadcast typing status to room
    this.server.to(`room:${data.roomId}`).emit('typingStatus', {
      roomId: data.roomId,
      typingUsers: Array.from(this.typingUsers.get(data.roomId) || []),
    });
  }

  @UseGuards(WsJwtVerifyGuard)
  @SubscribeMessage('markAsRead')
  async handleMarkAsRead(
    @ConnectedSocket() client: SocketWithUserAndDecodedAccessToken,
    @MessageBody() data: { roomId: string; messageIds: string[] },
  ) {
    const userId = client.data.user.id;
    await this.chatService.markMessagesAsRead(userId, data.messageIds);

    // Notify other participants
    this.server.to(`room:${data.roomId}`).emit('messagesRead', {
      userId,
      messageIds: data.messageIds,
    });

    return { success: true };
  }

  private addTypingUser(roomId: string, userId: string) {
    if (!this.typingUsers.has(roomId)) {
      this.typingUsers.set(roomId, new Set());
    }
    this.typingUsers.get(roomId)?.add(userId);
  }

  private removeTypingUser(roomId: string, userId: string) {
    this.typingUsers.get(roomId)?.delete(userId);
    if (this.typingUsers.get(roomId)?.size === 0) {
      this.typingUsers.delete(roomId);
    }
  }
}
