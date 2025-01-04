import { applyDecorators, UseGuards } from '@nestjs/common';
import {
  ApiBody,
  ApiHeader,
  ApiOperation,
  ApiParam,
  ApiQuery,
} from '@nestjs/swagger';
import { ApiQueryLimitAndPage } from 'src/decorators/pagination.decorators';
import { Roles } from 'src/decorators/roles.decorator';
import { RolesLevel } from 'src/global/enums.global';
import { JwtTokenVerifyGuard } from 'src/guards/jwt-token-verify.guard';
import { GeneratePostDto } from 'src/resources/post/dto/ai.dto';

export const getPostsDecorator = () =>
  applyDecorators(
    ApiQueryLimitAndPage(),
    ApiOperation({
      summary: 'Get posts list',
      description:
        'Retrieve a paginated list of posts with optional filters for keywords and user interactions',
    }),
    ApiQuery({
      name: 'keywords',
      required: false,
    }),
    ApiQuery({
      name: 'userId',
      description: 'Filter posts by specific user ID',
      required: false,
    }),
    ApiQuery({
      name: 'likeUserId',
      description: 'User ID to check like status of posts for this user',
      required: false,
    }),
  );

export const getMyPostsDecorator = () =>
  applyDecorators(
    ApiQueryLimitAndPage(),
    UseGuards(JwtTokenVerifyGuard),
    ApiHeader({
      name: 'accessToken',
      required: true,
    }),
    ApiOperation({
      summary: 'Get my posts list',
      description:
        'Retrieve a paginated list of posts created by the authenticated user',
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
      summary: 'Get post details',
      description:
        'Retrieve detailed information for a specific post using its ID',
    }),
  );

export const getTrendingTopicsDecorator = () =>
  applyDecorators(
    ApiOperation({
      summary: 'Get trending topics',
      description:
        'Retrieve a list of popular topics based on recent post engagement and activity',
    }),
  );

export const likePostDecorator = () =>
  applyDecorators(
    UseGuards(JwtTokenVerifyGuard),
    ApiOperation({
      summary: 'Toggle post like',
      description: 'Toggle the like status of a post. Authentication required.',
    }),
    ApiHeader({
      name: 'accessToken',
      required: true,
    }),
    ApiParam({
      name: 'postId',
    }),
  );

export const aiGeneratePostDecorator = () =>
  applyDecorators(
    UseGuards(JwtTokenVerifyGuard),
    ApiOperation({
      summary: 'Generate AI post',
      description:
        'Generate post content using AI technology. Authentication required.',
    }),
    ApiHeader({
      name: 'accessToken',
      required: true,
    }),
    ApiBody({
      type: GeneratePostDto,
    }),
  );

export const getLikesPostDecorator = () =>
  applyDecorators(
    ApiOperation({
      summary: 'Get post likes',
      description:
        'Retrieve a paginated list of users who have liked the specified post',
    }),
    ApiQueryLimitAndPage(),
    ApiParam({
      name: 'postId',
      required: true,
      description: 'The ID of the post to retrieve likes for',
    }),
    ApiQuery({
      name: 'userId',
      required: false,
      description: 'Optional user ID to check if posts are liked by this user',
    }),
  );

export const createPostDecorator = () =>
  applyDecorators(
    UseGuards(JwtTokenVerifyGuard),
    ApiOperation({
      summary: 'Create post',
      description:
        'Create a new post with the provided content. Authentication required.',
    }),
    ApiHeader({
      name: 'accessToken',
      required: true,
    }),
  );

export const updatePostDecorator = () =>
  applyDecorators(
    ApiOperation({
      summary: 'Update post',
      description:
        'Update an existing post. Requires authentication and post ownership.',
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
      summary: 'Update post (Manager)',
      description:
        'Update any post content with manager-level access privileges',
    }),
    Roles([RolesLevel.MANAGER]),
  );

export const deletePostDecorator = () =>
  applyDecorators(
    ApiOperation({
      summary: 'Delete post',
      description:
        'Delete an existing post. Requires authentication and post ownership.',
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
      summary: 'Delete post (Admin)',
      description: 'Delete any post with administrator-level access privileges',
    }),
    Roles([RolesLevel.ADMIN]),
  );
