import { applyDecorators, UseGuards } from '@nestjs/common';
import { ApiHeader, ApiOperation, ApiParam } from '@nestjs/swagger';
import { ApiQueryLimitAndPage } from 'src/decorators/pagination.decorators';
import { JwtTokenVerifyGuard } from 'src/guards/jwt-token-verify.guard';

const authHeader = () =>
  ApiHeader({
    name: 'accessToken',
    description: 'Access token',
    required: true,
  });

export const presignStoryUploadDecorator = () =>
  applyDecorators(
    UseGuards(JwtTokenVerifyGuard),
    ApiOperation({
      summary: 'Presign a story upload',
      description:
        'Get a presigned URL (or multipart URLs) to upload story media directly to storage',
    }),
    authHeader(),
  );

export const completeStoryUploadDecorator = () =>
  applyDecorators(
    UseGuards(JwtTokenVerifyGuard),
    ApiOperation({ summary: 'Complete a multipart story upload' }),
    authHeader(),
  );

export const createStoryDecorator = () =>
  applyDecorators(
    UseGuards(JwtTokenVerifyGuard),
    ApiOperation({
      summary: 'Create a story',
      description:
        'Create the story record after its media has been uploaded (expires after 24h)',
    }),
    authHeader(),
  );

export const getStoryFeedDecorator = () =>
  applyDecorators(
    UseGuards(JwtTokenVerifyGuard),
    ApiOperation({
      summary: 'Get story feed',
      description:
        'Active stories from the user, their followings and friends, grouped by author',
    }),
    ApiQueryLimitAndPage(),
    authHeader(),
  );

export const getUserStoriesDecorator = () =>
  applyDecorators(
    UseGuards(JwtTokenVerifyGuard),
    ApiOperation({ summary: 'Get a user active stories' }),
    authHeader(),
    ApiParam({ name: 'userId' }),
  );

export const viewStoryDecorator = () =>
  applyDecorators(
    UseGuards(JwtTokenVerifyGuard),
    ApiOperation({ summary: 'Mark a story as viewed' }),
    authHeader(),
    ApiParam({ name: 'storyId' }),
  );

export const getStoryViewersDecorator = () =>
  applyDecorators(
    UseGuards(JwtTokenVerifyGuard),
    ApiOperation({ summary: 'Get viewers of your story' }),
    authHeader(),
    ApiParam({ name: 'storyId' }),
  );

export const deleteStoryDecorator = () =>
  applyDecorators(
    UseGuards(JwtTokenVerifyGuard),
    ApiOperation({ summary: 'Delete your story' }),
    authHeader(),
    ApiParam({ name: 'storyId' }),
  );
