import { Module } from '@nestjs/common';
import { PrismaModule } from 'src/prisma/prisma.module';
import { UserGateway } from './user.gateway';

@Module({
  imports: [PrismaModule],
  providers: [UserGateway],
})
export class UserGatewayModule {}
