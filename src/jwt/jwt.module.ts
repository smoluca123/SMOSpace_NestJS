import { Global, Module } from '@nestjs/common';
import { ConfigModule } from '@nestjs/config';
import { JwtModule } from '@nestjs/jwt';
import { JwtConfigService } from 'src/jwt/jwt-config.service';
import { JwtServiceCustom } from 'src/jwt/jwt.service';

@Global()
@Module({
  imports: [
    JwtModule.registerAsync({
      global: true,
      imports: [ConfigModule],
      useClass: JwtConfigService,
    }),
  ],
  providers: [JwtServiceCustom],
  exports: [JwtServiceCustom],
})
export class JwtModuleCustom {}
