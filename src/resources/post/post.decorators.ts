import { applyDecorators, UseGuards } from '@nestjs/common';
import { ApiHeader } from '@nestjs/swagger';
import { JwtTokenVerifyGuard } from 'src/guards/jwt-token-verify.guard';

export const createPostDecorator = () =>
  applyDecorators(
    UseGuards(JwtTokenVerifyGuard),
    ApiHeader({
      name: 'accessToken',
      required: true,
    }),
  );
