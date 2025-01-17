import { Module } from '@nestjs/common';
import { PostCommentService } from './post-comment.service';
import { PostCommentController } from './post-comment.controller';
import { PostModule } from 'src/resources/post/post.module';
import { PostService } from 'src/resources/post/post.service';
import { PostGatewayModule } from 'src/resources/gateways/post/post.module';
import { CommentGatewayModule } from 'src/resources/gateways/comment/comment.module';

@Module({
  imports: [PostModule, PostGatewayModule, CommentGatewayModule],
  controllers: [PostCommentController],
  providers: [PostCommentService, PostService],
})
export class PostCommentModule {}
