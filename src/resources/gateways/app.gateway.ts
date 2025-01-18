import { RedisService } from '@liaoliaots/nestjs-redis';
import { UseGuards } from '@nestjs/common';
import { OnGatewayConnection, WebSocketGateway } from '@nestjs/websockets';
import { Redis } from 'ioredis';
import { Socket } from 'socket.io';
import { WsJwtGuard } from 'src/guards/ws-auth.guard';

@UseGuards(WsJwtGuard)
@WebSocketGateway({
  cors: {
    origin: '*',
  },
})
export class AppGateway implements OnGatewayConnection {
  private redis: Redis | null;
  constructor(private readonly redisService: RedisService) {
    this.redis = this.redisService.getOrThrow();
  }

  async handleConnection(client: Socket) {
    console.log('Client connected:', client.id);
  }
}
