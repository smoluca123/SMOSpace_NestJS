import { RedisService } from '@liaoliaots/nestjs-redis';
import {
  CanActivate,
  ExecutionContext,
  Injectable,
  UnauthorizedException,
} from '@nestjs/common';
import { Reflector } from '@nestjs/core';
import { Redis } from 'ioredis';
import { Roles } from 'src/decorators/roles.decorator';
import { IRequestWithDecodedAuthToken } from 'src/interfaces/interfaces.global';
import { PrismaService } from 'src/prisma/prisma.service';

@Injectable()
export class RoleGuard implements CanActivate {
  private redis: Redis | null;
  constructor(
    private reflector: Reflector,
    private prisma: PrismaService,
    private readonly redisService: RedisService,
  ) {
    this.redis = this.redisService.getOrThrow();
  }

  async canActivate(context: ExecutionContext): Promise<boolean> {
    const rolesLevel = this.reflector.get<number[]>(
      Roles,
      context.getHandler(),
    );

    if (!rolesLevel) return true;
    const minRoleLevel = Math.min(...rolesLevel);

    const request = context.switchToHttp().getRequest();
    const {
      user: { id, auth_code: authCode },
    } = request as IRequestWithDecodedAuthToken;

    const cacheKey = `role_${id}_${authCode}`;
    let cachedRole: string | number = await this.redis.get(cacheKey);

    if (!cachedRole) {
      const auth = await this.prisma.authCode.findUnique({
        where: {
          id,
          authCode,
        },
      });

      if (!auth) {
        throw new UnauthorizedException('Invalid authentication');
      }

      await this.redis.set(cacheKey, auth.roleLevel);

      // await this.redisCache.set(cacheKey, auth.roleLevel, 10);
      cachedRole = auth.roleLevel;
    }

    if (Number(cachedRole) < minRoleLevel) {
      throw new UnauthorizedException('Insufficient permissions');
    }

    return true;
  }
}
