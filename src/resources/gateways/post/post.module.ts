import { Module } from '@nestjs/common';
import { PostGateway } from 'src/resources/gateways/post/post.gateway';

@Module({
  providers: [PostGateway],
  exports: [PostGateway],
})
export class PostGatewayModule {}
