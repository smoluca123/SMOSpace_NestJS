import { Module } from '@nestjs/common';
import { AppController } from './app.controller';
import { AppService } from './app.service';
import { ConfigModule } from '@nestjs/config';
import configuration from 'src/configs/configuration';
import { JwtModule } from '@nestjs/jwt';
import { JwtConfigService } from 'src/jwt/jwt-config.service';
import { ThrottlerModule } from '@nestjs/throttler';
import { JwtStrategy } from 'src/strategy/jwt.strategy';
import { PrismaModule } from 'src/prisma/prisma.module';
import { AuthModule } from 'src/resources/auth/auth.module';

@Module({
  imports: [
    ConfigModule.forRoot({
      isGlobal: true,
      load: [configuration],
    }),
    JwtModule.registerAsync({
      global: true,
      imports: [ConfigModule],
      useClass: JwtConfigService,
    }),
    ThrottlerModule.forRoot([{ ttl: 2000, limit: 100 }]),
    PrismaModule,
    AuthModule,
  ],
  controllers: [AppController],
  providers: [AppService, JwtStrategy],
})
export class AppModule {}
