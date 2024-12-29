import { ConfigService } from '@nestjs/config';
import { Strategy, ExtractJwt } from 'passport-jwt';
import { PassportStrategy } from '@nestjs/passport';
import { Inject, Injectable, UnauthorizedException } from '@nestjs/common';
import { PrismaService } from 'src/prisma/prisma.service';
import { Cache } from '@nestjs/cache-manager';
import { RedisClientService } from 'src/cache/redis.service';
// import { Cache } from 'cache-manager';

@Injectable()
export class JwtStrategy extends PassportStrategy(Strategy) {
  constructor(
    readonly config: ConfigService,
    readonly prisma: PrismaService,
    readonly redisClientService: RedisClientService,
    @Inject('REDIS_CACHE') readonly redisCache: Cache,
  ) {
    super({
      jwtFromRequest: ExtractJwt.fromAuthHeaderAsBearerToken(),
      ignoreExpiration: false,
      secretOrKey: config.get('JWT_SECRET'),
    });
  }

  async validate(payload: { id: string; authCode: string }) {
    const cacheKey = `authCode:${payload.id}`;
    const cachedAuthCode = await this.redisClientService.client.get(cacheKey);
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
      await this.redisClientService.client.set(cacheKey, 1);
    }
    return payload;
  }
}
