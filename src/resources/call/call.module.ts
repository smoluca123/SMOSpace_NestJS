import { Module } from '@nestjs/common';
import { PrismaModule } from 'src/prisma/prisma.module';
import { ChatModule } from 'src/resources/chat/chat.module';
import { CallGateway } from 'src/resources/call/call.gateway';
import { CallController } from 'src/resources/call/call.controller';
import { CallService } from 'src/resources/call/call.service';

@Module({
  imports: [PrismaModule, ChatModule],
  controllers: [CallController],
  providers: [CallGateway, CallService],
})
export class CallModule {}
