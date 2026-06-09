import { UseGuards } from '@nestjs/common';
import {
  ConnectedSocket,
  OnGatewayDisconnect,
  SubscribeMessage,
  WebSocketGateway,
  WebSocketServer,
} from '@nestjs/websockets';
import { Server, Socket } from 'socket.io';
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
export class NotificationGateway implements OnGatewayDisconnect {
  @WebSocketServer()
  private server: Server;
  constructor(private readonly pushService: PushService) {}

  handleDisconnect(client: Socket) {
    if (client.data.user) {
      client.leave(`noti:to-${client.data.user.id}`);
    }
  }

  @UseGuards(WsJwtVerifyGuard)
  @SubscribeMessage('noti:subscribe')
  handleSubscribeNotification(
    @ConnectedSocket() client: SocketWithUserAndDecodedAccessToken,
  ) {
    console.log('subscribe notification');
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
