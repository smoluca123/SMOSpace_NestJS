import { ConfigService } from '@nestjs/config';
import { Strategy, ExtractJwt } from 'passport-jwt';
import { PassportStrategy } from '@nestjs/passport';
import { Injectable, UnauthorizedException } from '@nestjs/common';
import { PrismaService } from 'src/prisma/prisma.service';
import { RedisService } from 'src/cache/redis.service';

@Injectable()
export class JwtStrategy extends PassportStrategy(Strategy) {
  constructor(
    readonly config: ConfigService,
    readonly prisma: PrismaService,
    readonly redisCache: RedisService,
  ) {
    super({
      jwtFromRequest: ExtractJwt.fromAuthHeaderAsBearerToken(),
      ignoreExpiration: false,
      secretOrKey: config.get('JWT_SECRET'),
    });
  }

  async validate(payload: { id: string; authCode: string }) {
    const cacheKey = `authCode:${payload.id}`;
    const cachedAuthCode = await this.redisCache.client.getBit(cacheKey, 0);
    if (!cachedAuthCode) {
      console.log(cachedAuthCode);
      const auth = await this.prisma.authCode.findFirst({
        where: {
          id: payload.id,
          AND: {
            authCode: payload.authCode,
          },
        },
      });
      if (!auth) throw new UnauthorizedException();
      await this.redisCache.client.setBit(cacheKey, 0, 1);
    }
    return payload;
  }
}
