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
  constructor() {}

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
  }
}
