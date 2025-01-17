import { RedisService } from '@liaoliaots/nestjs-redis';

import { UseGuards, UsePipes } from '@nestjs/common';
import {
  ConnectedSocket,
  MessageBody,
  OnGatewayDisconnect,
  SubscribeMessage,
  WebSocketGateway,
} from '@nestjs/websockets';

import { Redis } from 'ioredis';
import { Socket } from 'socket.io';
import { WsJwtGuard } from 'src/guards/ws-auth.guard';
import { WsJwtVerifyGuard } from 'src/guards/ws-jwt-verify.guard';
import { SocketWithUserAndDecodedAccessToken } from 'src/interfaces/interfaces.global';
import { ZodValidationPipe } from 'src/pipes/zod.pipe';
import {
  UserOnline,
  UserOnlineSchema,
} from 'src/resources/gateways/user/schemas/user.schemas';

@UseGuards(WsJwtGuard)
@WebSocketGateway({
  namespace: 'user',
  cors: {
    origin: '*',
  },
})
export class UserGateway implements OnGatewayDisconnect {
  private redis: Redis | null;
  constructor(private readonly redisService: RedisService) {
    this.redis = this.redisService.getOrThrow();
  }

  // async handleConnection(client: Socket) {
  //   console.log('Client connected:', client.id);
  // }
  @UseGuards(WsJwtVerifyGuard)
  @UsePipes(new ZodValidationPipe(UserOnlineSchema))
  @SubscribeMessage('user:online')
  async handleOnline(
    @MessageBody() data: UserOnline,
    @ConnectedSocket() client: SocketWithUserAndDecodedAccessToken,
  ) {
    const userId = client.data.user.id;
    const status = data.status || 'online';
    await this.redis.hset('online:users', userId, JSON.stringify({ status }));
    client.send({
      status: 'success',
      message: 'You are online',
      data,
    });
  }

  handleDisconnect(client: SocketWithUserAndDecodedAccessToken | Socket) {
    if (client.data.user) {
      this.redis.hdel('online:users', client.data.user.id);
    }
  }
}
