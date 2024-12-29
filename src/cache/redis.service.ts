import { Injectable, OnModuleInit } from '@nestjs/common';
import { ConfigService } from '@nestjs/config';
import { createClient, RedisClientType } from 'redis';

@Injectable()
export class RedisService implements OnModuleInit {
  public readonly client: RedisClientType;
  private readonly defaultTTL = 300; // 5 minutes

  constructor(private configService: ConfigService) {
    this.client = createClient({
      url: `redis://${this.configService.get('REDIS_HOST')}:${this.configService.get('REDIS_PORT')}`,
      password: this.configService.get('REDIS_PASSWORD'),
    });
  }

  async onModuleInit() {
    await this.client.connect();
  }

  async set(key: string, value: string | number | Buffer, ttl?: number) {
    return await this.client.set(key, value, {
      EX: ttl,
    });
  }

  // Helper method to set with default TTL
  async setEx(key: string, value: string, ttl?: number) {
    return await this.client.setEx(key, ttl || this.defaultTTL, value);
  }

  //   async set(key: string, value: string) {
  //     return await this.client.set(key, value);
  //   }

  //   async get(key: string) {
  //     return await this.client.get(key);
  //   }

  //   async del(key: string) {
  //     return await this.client.del(key);
  //   }
}
