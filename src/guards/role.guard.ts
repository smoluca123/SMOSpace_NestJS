import {
  CanActivate,
  ExecutionContext,
  Injectable,
  UnauthorizedException,
} from '@nestjs/common';
import { Reflector } from '@nestjs/core';
import { Roles } from 'src/decorators/roles.decorator';
import { IRequestWithDecodedAuthToken } from 'src/interfaces/interfaces.global';
import { PrismaService } from 'src/prisma/prisma.service';

@Injectable()
export class RoleGuard implements CanActivate {
  constructor(
    private reflector: Reflector,
    private prisma: PrismaService,
  ) {}

  async canActivate(context: ExecutionContext): Promise<boolean> {
    const rolesLevel = this.reflector.get<number[]>(
      Roles,
      context.getHandler(),
    );

    if (!rolesLevel) return true;
    const minRoleLevel = Math.min(...rolesLevel);

    const request = context.switchToHttp().getRequest();
    const {
      user: { id, authCode },
    } = request as IRequestWithDecodedAuthToken;

    const auth = await this.prisma.authCode.findUnique({
      where: {
        id,
        authCode,
      },
    });

    if (!auth || auth.roleLevel < minRoleLevel)
      throw new UnauthorizedException(
        'You are not authorized to perform this action.',
      );
    return true;
  }
}
