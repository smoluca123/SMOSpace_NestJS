import { ConfigService } from '@nestjs/config';
import { Strategy, ExtractJwt } from 'passport-jwt';
import { PassportStrategy } from '@nestjs/passport';
import { Injectable, UnauthorizedException } from '@nestjs/common';
import { PrismaService } from 'src/prisma/prisma.service';
// import { Cache, CACHE_MANAGER } from '@nestjs/cache-manager';
// import { CACHE_MANAGER } from '@nestjs/cache-manager';
// import { Cache } from 'cache-manager';
import { Redis } from 'ioredis';
import { RedisService } from '@liaoliaots/nestjs-redis';

@Injectable()
export class JwtStrategy extends PassportStrategy(Strategy) {
  private readonly redis: Redis | null;
  constructor(
    readonly config: ConfigService,
    readonly prisma: PrismaService,
    private readonly redisService: RedisService,
  ) {
    super({
      jwtFromRequest: ExtractJwt.fromAuthHeaderAsBearerToken(),
      ignoreExpiration: false,
      secretOrKey: config.get('JWT_SECRET'),
    });
    this.redis = this.redisService.getOrThrow();
  }

  async validate(payload: { id: string; authCode: string }) {
    const cacheKey = `authCode:${payload.id}`;
    const cachedAuthCode = await this.redis.get(cacheKey);
    if (!cachedAuthCode) {
      const auth = await this.prisma.authCode.findFirst({
        where: {
          id: payload.id,
          AND: {
            authCode: payload.authCode,
          },
        },
      });
      if (!auth) throw new UnauthorizedException();
      await this.redis.set(cacheKey, 1);
    }
    return payload;
  }
}
