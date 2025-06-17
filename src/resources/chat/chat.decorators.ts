import { applyDecorators, UseGuards } from '@nestjs/common';
import { ApiHeader, ApiOperation } from '@nestjs/swagger';
import { ApiQueryLimitAndPage } from 'src/decorators/pagination.decorators';
import { JwtTokenVerifyGuard } from 'src/guards/jwt-token-verify.guard';

export const getUserRoomsDecorator = () =>
  applyDecorators(
    ApiOperation({
      summary: 'Get user rooms',
      description: 'Get user rooms',
    }),
    ApiHeader({
      name: 'accessToken',
      description: 'Access token',
      required: true,
    }),
    ApiQueryLimitAndPage(),
    UseGuards(JwtTokenVerifyGuard),
  );

export const getRoomMessagesDecorator = () =>
  applyDecorators(
    ApiOperation({
      summary: 'Get room messages',
      description: 'Get room messages',
    }),
    ApiHeader({
      name: 'accessToken',
      description: 'Access token',
      required: true,
    }),
    ApiQueryLimitAndPage(),
    UseGuards(JwtTokenVerifyGuard),
  );

export const createDirectChatDecorator = () =>
  applyDecorators(
    ApiOperation({
      summary: 'Create direct chat',
      description: 'Create direct chat',
    }),
    ApiHeader({
      name: 'accessToken',
      description: 'Access token',
      required: true,
    }),
    UseGuards(JwtTokenVerifyGuard),
  );
