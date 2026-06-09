import { Global, Module } from '@nestjs/common';
import { PrismaModule } from 'src/prisma/prisma.module';
import { PushController } from 'src/resources/push/push.controller';
import { PushService } from 'src/resources/push/push.service';

@Global()
@Module({
  imports: [PrismaModule],
  controllers: [PushController],
  providers: [PushService],
  exports: [PushService],
})
export class PushModule {}
