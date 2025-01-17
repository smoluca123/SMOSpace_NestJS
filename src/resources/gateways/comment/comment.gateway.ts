import { RedisService } from '@liaoliaots/nestjs-redis';
import { UseGuards, UsePipes } from '@nestjs/common';
import {
  ConnectedSocket,
  MessageBody,
  OnGatewayConnection,
  SubscribeMessage,
  WebSocketGateway,
  WebSocketServer,
} from '@nestjs/websockets';
import { Server, Socket } from 'socket.io';
import { WsJwtGuard } from 'src/guards/ws-auth.guard';
import { PostCommentDataType } from 'src/libs/prisma-types';
import { ZodValidationPipe } from 'src/pipes/zod.pipe';
import {
  subscribeOnNewComment,
  SubscribeOnNewComment,
} from 'src/resources/gateways/comment/schemas/comment.schemas';

@UseGuards(WsJwtGuard)
@WebSocketGateway({
  cors: {
    origin: '*',
  },
  namespace: 'comment',
})
export class CommentGateway implements OnGatewayConnection {
  @WebSocketServer()
  private server: Server;
  constructor(private readonly redisService: RedisService) {}

  async handleConnection(client: Socket) {
    console.log('Client connected:', client.id);
  }

  @SubscribeMessage('comment:subscribeOnNewComment')
  @UsePipes(new ZodValidationPipe(subscribeOnNewComment))
  async subscribeOnNewComment(
    @MessageBody() data: SubscribeOnNewComment,
    @ConnectedSocket() client: Socket,
  ) {
    const { postId } = data;
    console.log('subscribeOnNewComment', postId);
    client.join(`subscribeOnNewComment:${postId}`);
  }

  async emitNewComment(data: PostCommentDataType) {
    this.server
      .to(`subscribeOnNewComment:${data.post.id}`)
      .emit('comment:onNewComment', data);
  }
}
