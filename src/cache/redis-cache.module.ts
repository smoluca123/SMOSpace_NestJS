// import { CACHE_MANAGER, CacheModule } from '@nestjs/cache-manager';
// import { Global, Module } from '@nestjs/common';
// import { ConfigModule, ConfigService } from '@nestjs/config';
// import * as redisStore from 'cache-manager-redis-store';
// import { RedisClientService } from 'src/cache/redis.service';

// @Global()
// @Module({
//   imports: [
//     CacheModule.registerAsync({
//       imports: [ConfigModule],
//       inject: [ConfigService],
//       useFactory: async (configService: ConfigService) => ({
//         store: redisStore,
//         host: configService.get('REDIS_HOST'),
//         port: configService.get('REDIS_PORT'),
//         password: configService.get('REDIS_PASSWORD'),
//         // isGlobal: true,
//         ttl: 300,
//         max: 100,
//       }),
//     }),
//   ],
//   providers: [
//     {
//       provide: 'REDIS_CACHE',
//       useFactory: (cacheManager: any) => cacheManager,
//       inject: [CACHE_MANAGER],
//     },
//     RedisClientService,
//   ],
//   exports: ['REDIS_CACHE', RedisClientService],
// })
// export class RedisCacheModule {}

// // redis-cache.module.ts
// // import { Module } from '@nestjs/common';
// // import { RedisService } from 'src/cache/redis.service';

// // @Module({
// //   imports: [],
// //   providers: [RedisService],
// //   exports: [RedisService],
// // })
// // export class RedisCacheModule {}
