import { Module } from '@nestjs/common';
import { AppController } from './app.controller';
import { AppService } from './app.service';
import { ConfigModule, ConfigService } from '@nestjs/config';
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
import { RoleGuard } from 'src/guards/role.guard';
import cacheConfig from 'src/configs/cache.config';
import { CacheModule } from '@nestjs/cache-manager';
// import * as redisStore from 'cache-manager-redis-store';
import { redisStore } from 'cache-manager-redis-yet';
@Module({
  imports: [
    ConfigModule.forRoot({
      isGlobal: true,
      load: [configuration, cacheConfig],
    }),
    // CacheModule.register({
    //   store: redisStore,
    //   host: 'bomvswlmlcox0vi52hk4-redis.services.clever-cloud.com',
    //   port: 40037,
    //   password: '25GVIQpUUiRaXrvJAaU',
    //   ttl: 0,
    //   max: 100,
    //   isGlobal: true,
    // }),
    CacheModule.registerAsync({
      imports: [ConfigModule],
      inject: [ConfigService],
      isGlobal: true,
      useFactory: async (configService: ConfigService) => ({
        store: await redisStore({
          url: `redis://${configService.get('REDIS_HOST')}:${configService.get('REDIS_PORT')}`,
          password: configService.get('REDIS_PASSWORD'),
          ttl: 300 * 1000, //5 minutes
        }),
        host: configService.get('REDIS_HOST'),
        port: configService.get('REDIS_PORT'),
        password: configService.get('REDIS_PASSWORD'),

        max: 100,
      }),
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
    {
      provide: APP_GUARD,
      useClass: AuthGuard('jwt'),
    },
    {
      provide: APP_GUARD,
      useClass: RoleGuard,
    },
  ],
})
export class AppModule {}
