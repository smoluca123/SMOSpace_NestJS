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
    const message = await this.chatService.createMessage(
      userId,
      createMessageDto,
    );

    // Broadcast to room
    this.server
      .to(`room:${createMessageDto.roomId}`)
      .emit('newMessage', message);

    // Notify participants who are not in the room
    const participants = await this.prisma.chatParticipant.findMany({
      where: {
        roomId: createMessageDto.roomId,
        leftAt: null,
      },
      select: {
        userId: true,
      },
    });
    participants.forEach((participant) => {
      if (participant.userId !== userId) {
        this.server
          .to(`user:${participant.userId}`)
          .emit('newMessage', message);
      }
    });

    return message;
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
