import { applyDecorators, UseGuards } from '@nestjs/common';
import { ApiHeader, ApiOperation } from '@nestjs/swagger';
import { Roles } from 'src/decorators/roles.decorator';
import { RolesLevel } from 'src/global/enums.global';
import { JwtTokenVerifyGuard } from 'src/guards/jwt-token-verify.guard';

export const createPostDecorator = () =>
  applyDecorators(
    UseGuards(JwtTokenVerifyGuard),
    ApiHeader({
      name: 'accessToken',
      required: true,
    }),
  );

export const updatePostDecorator = () =>
  applyDecorators(
    ApiOperation({
      summary: 'Update a post',
      description: 'Update a post API',
    }),
    UseGuards(JwtTokenVerifyGuard),
    ApiHeader({
      name: 'accessToken',
      required: true,
    }),
  );

export const updatePostAsAdminDecorator = () =>
  applyDecorators(
    ApiOperation({
      summary: 'Update a post (Managers only)',
      description: 'Update a post API (Managers only)',
    }),
    Roles([RolesLevel.MANAGER]),
  );

export const deletePostDecorator = () =>
  applyDecorators(
    ApiOperation({
      summary: 'Delete a post',
      description: 'Delete a post API',
    }),
    UseGuards(JwtTokenVerifyGuard),
    ApiHeader({
      name: 'accessToken',
      required: true,
    }),
  );

export const deletePostAsAdminDecorator = () =>
  applyDecorators(
    ApiOperation({
      summary: 'Delete a post (Administrators only)',
      description: 'Delete a post (Administrators only)',
    }),
    Roles([RolesLevel.ADMIN]),
  );
