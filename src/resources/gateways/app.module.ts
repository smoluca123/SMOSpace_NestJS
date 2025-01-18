import { Module } from '@nestjs/common';
import { AppGateway } from 'src/resources/gateways/app.gateway';
import { CommentGatewayModule } from 'src/resources/gateways/comment/comment.module';
import { PostGatewayModule } from 'src/resources/gateways/post/post.module';
import { UserGatewayModule } from 'src/resources/gateways/user/user.module';

@Module({
  imports: [PostGatewayModule, UserGatewayModule, CommentGatewayModule],
  providers: [AppGateway],
})
export class AppGatewayModule {}
