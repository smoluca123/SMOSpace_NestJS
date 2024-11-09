import { applyDecorators, UseGuards } from '@nestjs/common';
import { ApiHeader, ApiOperation, ApiParam } from '@nestjs/swagger';
import { Roles } from 'src/decorators/roles.decorator';
import { JwtTokenVerifyGuard } from 'src/guards/jwt-token-verify.guard';
import { RolesLevel } from 'src/interfaces/interfaces.global';

export const getInfomationDecorator = () =>
  applyDecorators(
    UseGuards(JwtTokenVerifyGuard),
    ApiOperation({
      summary: 'Get user infomation API',
      description: 'Get user infomation by accessToken API',
    }),
    ApiHeader({
      name: 'accessToken',
      required: true,
    }),
  );

export const getUserInfomationDecorator = () =>
  applyDecorators(
    Roles([RolesLevel.MANAGER]),
    ApiOperation({
      summary: 'Get user infomation API',
      description: 'Get user infomation by id API',
    }),
    ApiParam({
      name: 'userId',
      description: 'Param userId accepts sending to username',
    }),
  );

export const banUserDecorator = () =>
  applyDecorators(Roles([RolesLevel.ADMIN]));

export const updateInfomationDecorator = () =>
  applyDecorators(
    ApiOperation({
      summary: 'Update infomation API',
      description: 'Update infomation by accessToken API',
    }),
    ApiHeader({
      name: 'accessToken',
      required: true,
    }),
    UseGuards(JwtTokenVerifyGuard),
  );

export const updateUserInfomationDecorator = () =>
  applyDecorators(
    ApiOperation({
      summary: 'Update user infomation API',
      description: 'Update user infomation by id API',
    }),
  );
