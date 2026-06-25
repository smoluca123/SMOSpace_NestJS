import { RedisService } from '@liaoliaots/nestjs-redis';
import { UseGuards, UsePipes } from '@nestjs/common';
import {
  ConnectedSocket,
  MessageBody,
  OnGatewayConnection,
  OnGatewayDisconnect,
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
export class CommentGateway
  implements OnGatewayConnection, OnGatewayDisconnect
{
  @WebSocketServer()
  private server: Server;
  private socketRooms = new Map<string, Set<string>>();

  constructor(private readonly redisService: RedisService) {}

  async handleConnection(client: Socket) {}

  async handleDisconnect(client: Socket) {
    const rooms = this.socketRooms.get(client.id);
    if (rooms) {
      rooms.forEach((room) => client.leave(room));
      this.socketRooms.delete(client.id);
    }
  }

  @SubscribeMessage('comment:subscribeOnNewComment')
  @UsePipes(new ZodValidationPipe(subscribeOnNewComment))
  async subscribeOnNewComment(
    @MessageBody() data: SubscribeOnNewComment,
    @ConnectedSocket() client: Socket,
  ) {
    const { postId } = data;
    const room = `subscribeOnNewComment:${postId}`;
    client.join(room);

    if (!this.socketRooms.has(client.id)) {
      this.socketRooms.set(client.id, new Set());
    }
    this.socketRooms.get(client.id).add(room);
  }

  async emitNewComment(data: PostCommentDataType) {
    this.server
      .to(`subscribeOnNewComment:${data.post.id}`)
      .emit('comment:onNewComment', data);
  }
}
