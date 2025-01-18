import { RedisService } from '@liaoliaots/nestjs-redis';
import {
  OnGatewayConnection,
  WebSocketGateway,
  WebSocketServer,
} from '@nestjs/websockets';
import { Redis } from 'ioredis';
import { Server, Socket } from 'socket.io';
import { PostDataType } from 'src/libs/prisma-types';

@WebSocketGateway({
  cors: {
    origin: '*',
  },
  namespace: '/post',
})
export class PostGateway implements OnGatewayConnection {
  private redis: Redis | null;
  @WebSocketServer()
  private server: Server;
  constructor(private readonly redisService: RedisService) {
    this.redis = this.redisService.getOrThrow();
  }

  async handleConnection(client: Socket) {
    console.log('Client connected:', client.id);
  }

  async emitNewPost(data: PostDataType) {
    this.server.emit('post:onNewPost', data);
  }
}
