import { Module } from '@nestjs/common';
import { PostService } from './post.service';
import { PostController } from './post.controller';
import { PostGatewayModule } from 'src/resources/gateways/post/post.module';

@Module({
  imports: [PostGatewayModule],
  controllers: [PostController],
  providers: [PostService],
})
export class PostModule {}
