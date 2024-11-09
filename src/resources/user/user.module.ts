import { Module } from '@nestjs/common';
import { UserService } from './user.service';
import { UserController } from './user.controller';
import { SupabaseService } from 'src/supabase/supabase.service';

@Module({
  controllers: [UserController],
  providers: [UserService, SupabaseService],
})
export class UserModule {}
