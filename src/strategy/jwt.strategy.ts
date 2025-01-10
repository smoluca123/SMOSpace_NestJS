import { ConfigService } from '@nestjs/config';
import { Strategy, ExtractJwt } from 'passport-jwt';
import { PassportStrategy } from '@nestjs/passport';
import { Inject, Injectable, UnauthorizedException } from '@nestjs/common';
import { PrismaService } from 'src/prisma/prisma.service';
// import { Cache, CACHE_MANAGER } from '@nestjs/cache-manager';
import { CACHE_MANAGER } from '@nestjs/cache-manager';
import { Cache } from 'cache-manager';

@Injectable()
export class JwtStrategy extends PassportStrategy(Strategy) {
  constructor(
    readonly config: ConfigService,
    readonly prisma: PrismaService,
    @Inject(CACHE_MANAGER) private cacheManager: Cache,
  ) {
    super({
      jwtFromRequest: ExtractJwt.fromAuthHeaderAsBearerToken(),
      ignoreExpiration: false,
      secretOrKey: config.get('JWT_SECRET'),
    });
  }

  async validate(payload: { id: string; authCode: string }) {
    const cacheKey = `authCode:${payload.id}`;
    const cachedAuthCode = await this.cacheManager.get(cacheKey);
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
      await this.cacheManager.set(cacheKey, 1, 0);
    }
    return payload;
  }
}
