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
import cacheConfig from 'src/configs/cache.config';
// import * as redisStore from 'cache-manager-redis-store';
import { PostCommentModule } from 'src/resources/post-comment/post-comment.module';
import { RedisModule } from '@liaoliaots/nestjs-redis';
import { NotificationModule } from 'src/resources/notification/notification.module';
import { S3Module } from 'src/services/aws/s3/s3.module';
import { S3Service } from 'src/services/aws/s3/s3.service';
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
    // CacheModule.registerAsync({
    //   imports: [ConfigModule],
    //   inject: [ConfigService],
    //   isGlobal: true,
    //   useFactory: async (configService: ConfigService) => ({
    //     store: await redisStore({
    //       // url: `redis://${configService.get('REDIS_HOST')}:${configService.get('REDIS_PORT')}`,
    //       socket: {
    //         host: configService.get('REDIS_HOST'),
    //         port: configService.get('REDIS_PORT'),
    //         reconnectStrategy: (retries) => {
    //           // Thử kết nối lại sau mỗi 1s, tối đa 10 lần
    //           if (retries > 10) {
    //             return new Error('Không thể kết nối đến Redis sau 10 lần thử');
    //           }
    //           return 1000;
    //         },
    //       },
    //       password: configService.get('REDIS_PASSWORD'),
    //       ttl: 300 * 1000, //5 minutes
    //     }),
    //     // host: configService.get('REDIS_HOST'),
    //     // port: configService.get('REDIS_PORT'),
    //     // password: configService.get('REDIS_PASSWORD'),

    //     max: 100,
    //   }),
    // }),

    RedisModule.forRootAsync({
      imports: [ConfigModule],
      inject: [ConfigService],
      useFactory: async (configService: ConfigService) => ({
        config: {
          host: configService.get('REDIS_HOST'),
          port: configService.get('REDIS_PORT'),
          password: configService.get('REDIS_PASSWORD'),
          db: 0,
        },
      }),
    }),

    // CacheModule.registerAsync({
    //   imports: [ConfigModule],
    //   inject: [ConfigService],
    //   isGlobal: true,
    //   useFactory: async (configService: ConfigService) => {
    //     const store = await redisStore({
    //       socket: {
    //         host: configService.get('REDIS_HOST'),
    //         port: configService.get('REDIS_PORT'),

    //         reconnectStrategy: (retries) => {
    //           if (retries > 10) {
    //             return new Error('Không thể kết nối đến Redis sau 10 lần thử');
    //           }
    //           return 1000;
    //         },
    //       },
    //       password: configService.get('REDIS_PASSWORD'),
    //     });

    //     return {
    //       store: store as CacheStore,
    //       ttl: 300 * 1000, //5 minutes
    //       max: 100,
    //     };
    //   },
    // }),

    ThrottlerModule.forRoot([{ ttl: 2000, limit: 100, name: 'default' }]),
    JwtModuleCustom,
    PrismaModule,
    AuthModule,
    UserModule,
    PostCommentModule,
    PostModule,
    // AppGatewayModule,
    NotificationModule,
    S3Module,
  ],
  controllers: [AppController],
  providers: [
    AppService,
    JwtStrategy,
    S3Service,
    {
      provide: APP_GUARD,
      useClass: ThrottlerGuard,
    },
    // {
    //   provide: APP_GUARD,
    //   useClass: AuthGuard('jwt'),
    // },
    // {
    //   provide: APP_GUARD,
    //   useClass: RoleGuard,
    // },
  ],
})
export class AppModule {}
