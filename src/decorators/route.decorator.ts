import { applyDecorators, UseGuards } from '@nestjs/common';
import { ApiHeader, ApiOperation } from '@nestjs/swagger';
import { Roles } from 'src/decorators/roles.decorator';
import { JwtTokenVerifyGuard } from 'src/guards/jwt-token-verify.guard';
import { RoleGuard } from 'src/guards/role.guard';
import { RolesLevel } from 'src/interfaces/interfaces.global';

export function ApiPublicOperation(options?: {
  summary?: string;
  description?: string;
}) {
  return applyDecorators(
    ApiOperation({
      summary: options?.summary,
      description: options?.description,
    }),
  );
}

export function ApiProtectedAuthOperation(options?: {
  summary?: string;
  description?: string;
}) {
  return applyDecorators(
    ApiOperation({
      summary: options?.summary,
      description: options?.description,
    }),
    UseGuards(JwtTokenVerifyGuard),
    ApiHeader({
      name: 'accessToken',
      description: 'JWT access token',
      required: true,
    }),
  );
}

export function ApiRoleProtectedOperation(options?: {
  summary?: string;
  description?: string;
  roles?: RolesLevel[];
}) {
  return applyDecorators(
    ApiOperation({
      summary: options?.summary,
      description: options?.description,
    }),
    UseGuards(RoleGuard),
    Roles(options?.roles ?? [RolesLevel.ADMIN]),
  );
}
