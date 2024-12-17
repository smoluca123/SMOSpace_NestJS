import { applyDecorators, UseGuards } from '@nestjs/common';
import { ApiHeader, ApiOperation, ApiParam, ApiQuery } from '@nestjs/swagger';
import { ApiQueryLimitAndPage } from 'src/decorators/pagination.decorators';
import { Roles } from 'src/decorators/roles.decorator';
import { RolesLevel } from 'src/global/enums.global';
import { JwtTokenVerifyGuard } from 'src/guards/jwt-token-verify.guard';

export const getPostsDecorator = () =>
  applyDecorators(
    ApiQueryLimitAndPage(),
    ApiOperation({
      summary: 'Get all posts',
      description: 'Get all posts API',
    }),
    ApiQuery({
      name: 'keywords',
      required: false,
    }),
  );

export const getPostDecorator = () =>
  applyDecorators(
    ApiParam({
      name: 'postId',
    }),
    ApiOperation({
      summary: 'Get a post',
      description: 'Get a post API',
    }),
  );

export const getTrendingTopicsDecorator = () =>
  applyDecorators(
    ApiOperation({
      summary: 'Get trending topics',
      description: 'Get trending topics API',
    }),
  );

export const likePostDecorator = () =>
  applyDecorators(
    UseGuards(JwtTokenVerifyGuard),
    ApiOperation({
      summary: 'Like a post',
      description: 'Toggle like a post API',
    }),
    ApiHeader({
      name: 'accessToken',
      required: true,
    }),
    ApiParam({
      name: 'postId',
    }),
  );

export const getLikesPostDecorator = () =>
  applyDecorators(
    ApiQueryLimitAndPage(),
    ApiParam({
      name: 'postId',
      required: true,
    }),
  );

export const createPostDecorator = () =>
  applyDecorators(
    UseGuards(JwtTokenVerifyGuard),
    ApiOperation({
      summary: 'Create a post',
      description: 'Create a post API',
    }),
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
