import { Module } from '@nestjs/common';
import { AppGateway } from 'src/resources/gateways/app.gateway';

@Module({
  providers: [AppGateway],
})
export class AppGatewayModule {}
