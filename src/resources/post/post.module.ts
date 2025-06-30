import { Module } from '@nestjs/common';
import { PostService } from './post.service';
import { PostController } from './post.controller';
import { PostGatewayModule } from 'src/resources/gateways/post/post.module';
import { S3Service } from 'src/services/aws/s3/s3.service';
import { UserService } from 'src/resources/user/user.service';
import { SupabaseService } from 'src/services/supabase/supabase.service';
import { EmailService } from 'src/resources/email/email.service';

@Module({
  imports: [PostGatewayModule],
  controllers: [PostController],
  providers: [
    PostService,
    S3Service,
    UserService,
    SupabaseService,
    EmailService,
  ],
})
export class PostModule {}
