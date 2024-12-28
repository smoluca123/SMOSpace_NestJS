import { Module } from '@nestjs/common';
import { AppController } from './app.controller';
import { AppService } from './app.service';
import { ConfigModule } from '@nestjs/config';
import configuration from 'src/configs/configuration';
// import { JwtModule } from '@nestjs/jwt';
// import { JwtConfigService } from 'src/jwt/jwt-config.service';
import { ThrottlerGuard, ThrottlerModule } from '@nestjs/throttler';
import { JwtStrategy } from 'src/strategy/jwt.strategy';
import { PrismaModule } from 'src/prisma/prisma.module';
import { AuthModule } from 'src/resources/auth/auth.module';
import { JwtModuleCustom } from 'src/jwt/jwt.module';
import { UserModule } from 'src/resources/user/user.module';
import { PostModule } from 'src/resources/post/post.module';
import { APP_GUARD } from '@nestjs/core';
import { AuthGuard } from '@nestjs/passport';

@Module({
  imports: [
    ConfigModule.forRoot({
      isGlobal: true,
      load: [configuration],
    }),

    ThrottlerModule.forRoot([{ ttl: 2000, limit: 100, name: 'default' }]),
    JwtModuleCustom,
    PrismaModule,
    AuthModule,
    UserModule,
    PostModule,
  ],
  controllers: [AppController],
  providers: [
    AppService,
    JwtStrategy,
    {
      provide: APP_GUARD,
      useClass: ThrottlerGuard,
    },
    // {
    //   provide: APP_GUARD,
    //   useClass: AuthGuard('jwt'),
    // },
  ],
})
export class AppModule {}
