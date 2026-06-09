import { Module } from '@nestjs/common';
import { PrismaModule } from 'src/prisma/prisma.module';
import { ChatModule } from 'src/resources/chat/chat.module';
import { CallGateway } from 'src/resources/call/call.gateway';

@Module({
  imports: [PrismaModule, ChatModule],
  providers: [CallGateway],
})
export class CallModule {}
