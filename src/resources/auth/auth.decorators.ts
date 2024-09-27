import { applyDecorators, UseGuards } from '@nestjs/common';
import { ApiOperation } from '@nestjs/swagger';
import { JwtTokenVerifyGuard } from 'src/guards/jwt-token-verify.guard';

export const decoratorsAuthLogin = () =>
  applyDecorators(
    ApiOperation({
      summary: 'User Login API',
      description: 'User Login API',
    }),
  );

export const decoratorsAuthRegister = () =>
  applyDecorators(
    ApiOperation({
      summary: 'User Registration API',
      description: 'User Registration API',
    }),
  );
export const decoratorsAuthLogout = () =>
  applyDecorators(
    UseGuards(JwtTokenVerifyGuard),
    ApiOperation({
      summary: 'User Logout API',
      description: 'User Logout API, clear cookies',
    }),
    // ApiHeader({ name: 'accessToken', required: !!requireAccessToken }),
  );
