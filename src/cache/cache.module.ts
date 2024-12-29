import { Global, Module } from '@nestjs/common';
import { CacheModule as CacheModuleNest } from '@nestjs/cache-manager';

@Global()
@Module({
  imports: [
    // Cấu hình in-memory cache
    CacheModuleNest.register({
      isGlobal: true,
      store: 'memory',
      ttl: 1000 * 60 * 5, // 5 minutes in milliseconds
      max: 1000,
    }),
  ],
  providers: [],
  exports: [CacheModuleNest],
})
export class CacheModule {}
