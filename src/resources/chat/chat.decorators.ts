import { applyDecorators, UseGuards } from '@nestjs/common';
import { ApiHeader, ApiOperation } from '@nestjs/swagger';
import { ApiQueryLimitAndPage } from 'src/decorators/pagination.decorators';
import { JwtTokenVerifyGuard } from 'src/guards/jwt-token-verify.guard';

/**
 * Base decorator for every authenticated chat endpoint: documents the operation,
 * declares the required access token header and applies the verify guard.
 * Keeps controller methods free of repeated guard/Swagger boilerplate.
 */
export const chatEndpointDecorator = (summary: string, description?: string) =>
  applyDecorators(
    ApiOperation({ summary, description: description ?? summary }),
    ApiHeader({
      name: 'accessToken',
      description: 'Access token',
      required: true,
    }),
    UseGuards(JwtTokenVerifyGuard),
  );

/**
 * Same as {@link chatEndpointDecorator} but also documents `limit`/`page`
 * query params for paginated endpoints.
 */
export const chatPaginatedEndpointDecorator = (
  summary: string,
  description?: string,
) =>
  applyDecorators(
    chatEndpointDecorator(summary, description),
    ApiQueryLimitAndPage(),
  );

export const getUserRoomsDecorator = () =>
  chatPaginatedEndpointDecorator('Get user rooms');

export const getRoomMessagesDecorator = () =>
  chatPaginatedEndpointDecorator('Get room messages');

export const createDirectChatDecorator = () =>
  chatEndpointDecorator('Create direct chat');
