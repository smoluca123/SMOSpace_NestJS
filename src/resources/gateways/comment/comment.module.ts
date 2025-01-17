import { Module } from '@nestjs/common';
import { CommentGateway } from 'src/resources/gateways/comment/comment.gateway';

@Module({
  providers: [CommentGateway],
  exports: [CommentGateway],
})
export class CommentGatewayModule {}
