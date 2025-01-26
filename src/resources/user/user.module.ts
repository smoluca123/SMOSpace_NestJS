import { Module } from '@nestjs/common';
import { UserService } from './user.service';
import { UserController } from './user.controller';
import { SupabaseService } from 'src/services/supabase/supabase.service';
import { EmailModule } from 'src/resources/email/email.module';
import { S3Service } from 'src/services/aws/s3/s3.service';

@Module({
  imports: [EmailModule],
  controllers: [UserController],
  providers: [UserService, SupabaseService, S3Service],
})
export class UserModule {}
