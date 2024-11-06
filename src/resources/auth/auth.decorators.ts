import { applyDecorators, UseGuards } from '@nestjs/common';
import { ApiHeader, ApiOperation } from '@nestjs/swagger';
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

export const decoratorsValidateSession = () =>
  applyDecorators(
    UseGuards(JwtTokenVerifyGuard),
    ApiOperation({
      summary: 'Validate Session API',
      description: 'Validate Session API',
    }),
    ApiHeader({
      name: 'accessToken',
      required: true,
    }),
  );

export const decoratorsAuthLogout = () =>
  applyDecorators(
    UseGuards(JwtTokenVerifyGuard),
    ApiOperation({
      summary: 'User Logout API',
      description: 'User Logout API, clear cookies',
    }),
    ApiHeader({
      name: 'accessToken',
      required: true,
    }),
  );
