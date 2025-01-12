import { applyDecorators, UseGuards } from '@nestjs/common';
import { ApiHeader, ApiOperation } from '@nestjs/swagger';
import { ApiQueryLimitAndPage } from 'src/decorators/pagination.decorators';
import { JwtTokenVerifyGuard } from 'src/guards/jwt-token-verify.guard';

export const createPostCommentDecorator = () =>
  applyDecorators(
    UseGuards(JwtTokenVerifyGuard),
    ApiHeader({
      name: 'accessToken',
      required: true,
    }),
    ApiOperation({
      summary: 'Create post comment',
      description:
        'Create a new comment for a specific post. Requires authentication.',
    }),
  );

export const getPostCommentDecorator = () =>
  applyDecorators(
    ApiOperation({
      summary: 'Get post comments',
      description:
        'Retrieve all comments for a specific post with pagination support',
    }),
    ApiQueryLimitAndPage(),
  );
