import {
  CanActivate,
  ExecutionContext,
  Injectable,
  UnauthorizedException,
} from '@nestjs/common';
import { Reflector } from '@nestjs/core';
import { RedisClientService } from 'src/cache/redis.service';
import { Roles } from 'src/decorators/roles.decorator';
import { IRequestWithDecodedAuthToken } from 'src/interfaces/interfaces.global';
import { PrismaService } from 'src/prisma/prisma.service';

@Injectable()
export class RoleGuard implements CanActivate {
  constructor(
    private reflector: Reflector,
    private prisma: PrismaService,
    private redisClientService: RedisClientService,
  ) {}

  async canActivate(context: ExecutionContext): Promise<boolean> {
    const rolesLevel = this.reflector.get<number[]>(
      Roles,
      context.getHandler(),
    );

    if (!rolesLevel) return true;
    const minRoleLevel = Math.min(...rolesLevel);

    const request = context.switchToHttp().getRequest();
    console.log(request.user);
    const {
      user: { id, auth_code: authCode },
    } = request as IRequestWithDecodedAuthToken;

    const cacheKey = `role_${id}_${authCode}`;
    let cachedRole: string | number =
      await this.redisClientService.client.get(cacheKey);

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

      await this.redisClientService.client.set(cacheKey, auth.roleLevel);

      // await this.redisCache.set(cacheKey, auth.roleLevel, 10);
      cachedRole = auth.roleLevel;
    }

    if (Number(cachedRole) < minRoleLevel) {
      throw new UnauthorizedException('Insufficient permissions');
    }

    return true;
  }
}
