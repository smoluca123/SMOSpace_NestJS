import { applyDecorators, UseGuards } from '@nestjs/common';
import { ApiHeader, ApiOperation, ApiParam } from '@nestjs/swagger';
import { ApiQueryLimitAndPage } from 'src/decorators/pagination.decorators';
import { JwtTokenVerifyGuard } from 'src/guards/jwt-token-verify.guard';

export const getUserNotificationsDecorator = () =>
  applyDecorators(
    ApiOperation({
      summary: 'Get notifications',
      description: 'Get notifications',
    }),
    ApiParam({
      name: 'userId',
      description: 'User ID',
    }),
    ApiQueryLimitAndPage(),
  );

export const getNotificationsDecorator = () =>
  applyDecorators(
    ApiOperation({
      summary: 'Get notifications',
      description: 'Get notifications',
    }),
    UseGuards(JwtTokenVerifyGuard),
    ApiHeader({
      name: 'accessToken',
      required: true,
      description: 'Access token',
    }),
    ApiQueryLimitAndPage(),
  );
