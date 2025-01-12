import { applyDecorators, UseGuards } from '@nestjs/common';
import { ApiHeader, ApiOperation } from '@nestjs/swagger';
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
      description: 'Create comment for post',
    }),
  );
