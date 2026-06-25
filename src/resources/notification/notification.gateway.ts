import { UseGuards } from '@nestjs/common';
import {
  ConnectedSocket,
  OnGatewayConnection,
  OnGatewayDisconnect,
  SubscribeMessage,
  WebSocketGateway,
  WebSocketServer,
} from '@nestjs/websockets';
import { Server } from 'socket.io';
import { JwtService } from '@nestjs/jwt';
import { PrismaService } from 'src/prisma/prisma.service';
import { WsJwtGuard } from 'src/guards/ws-auth.guard';
import { WsJwtVerifyGuard } from 'src/guards/ws-jwt-verify.guard';
import { SocketWithUserAndDecodedAccessToken } from 'src/interfaces/interfaces.global';
import { NotificationDataType } from 'src/libs/prisma-types';
import { PushService } from 'src/resources/push/push.service';

@UseGuards(WsJwtGuard)
@WebSocketGateway({
  namespace: 'notification',
  cors: {
    origin: '*',
  },
})
export class NotificationGateway
  implements OnGatewayConnection, OnGatewayDisconnect
{
  @WebSocketServer()
  private server: Server;

  constructor(
    private readonly pushService: PushService,
    private readonly jwtService: JwtService,
    private readonly prisma: PrismaService,
  ) {}

  async handleConnection(client: SocketWithUserAndDecodedAccessToken) {
    try {
      const rawToken =
        client.handshake.auth.accessToken ||
        client.handshake.headers.accesstoken;

      if (!rawToken) {
        client.disconnect(true);
        return;
      }

      const token = rawToken.replace('Bearer ', '');
      const decoded = this.jwtService.verify(token);
      const user = await this.prisma.user.findUnique({
        where: { id: decoded.userId },
        select: { id: true, username: true, fullName: true },
      });

      if (!user) {
        client.disconnect(true);
        return;
      }

      (client.data as any).user = user;
      (client.data as any).decodedToken = decoded;
    } catch (error) {
      client.disconnect(true);
    }
  }

  handleDisconnect(client: SocketWithUserAndDecodedAccessToken) {
    if (client.data?.user) {
      client.leave(`noti:to-${client.data.user.id}`);
    }
  }

  @UseGuards(WsJwtVerifyGuard)
  @SubscribeMessage('noti:subscribe')
  handleSubscribeNotification(
    @ConnectedSocket() client: SocketWithUserAndDecodedAccessToken,
  ) {
    client.join(`noti:to-${client.data.user.id}`);
    client.send({
      status: 'success',
      message: 'You are subscribed to notification',
    });
  }

  async emitNewNotification(data: NotificationDataType) {
    this.server.to(`noti:to-${data.recipientId}`).emit('noti:new', data);

    // Also deliver via Web Push so the user is reached even when offline / the
    // tab is closed. Best-effort: never let push failures affect the socket path.
    const content = (data.content ?? {}) as {
      title?: string;
      message?: string;
    };
    void this.pushService
      .sendToUser(data.recipientId, {
        title: content.title || 'New notification',
        body: content.message || 'You have a new notification',
        url: '/',
        tag: data.id,
      })
      .catch(() => undefined);
  }
}
