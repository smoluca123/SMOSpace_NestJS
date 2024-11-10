import { Module } from '@nestjs/common';
import { UserService } from './user.service';
import { UserController } from './user.controller';
import { SupabaseService } from 'src/supabase/supabase.service';
import { EmailModule } from 'src/resources/email/email.module';

@Module({
  imports: [EmailModule],
  controllers: [UserController],
  providers: [UserService, SupabaseService],
})
export class UserModule {}
