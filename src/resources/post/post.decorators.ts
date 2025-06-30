import { applyDecorators, UseGuards, UseInterceptors } from '@nestjs/common';
import { FilesInterceptor } from '@nestjs/platform-express';
import {
  ApiBody,
  ApiConsumes,
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
import { GenerateImagesDto } from 'src/resources/post/dto/post.dto';

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

export const getPostsAdminDecorator = () =>
  applyDecorators(
    ApiQueryLimitAndPage(),
    ApiOperation({
      summary: 'Get posts list (Manager)',
      description:
        'Retrieve a paginated list of posts with optional filters for keywords and user interactions',
    }),
    ApiQuery({
      name: 'keywords',
      required: false,
    }),
    Roles([RolesLevel.MANAGER]),
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
    ApiQuery({
      name: 'likeUserId',
      required: false,
      description: 'User ID to check like status of posts for this user',
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
    ApiConsumes('multipart/form-data'),
    ApiOperation({
      summary: 'Create post',
      description:
        'Create a new post with the provided content. Authentication required.',
    }),
    ApiHeader({
      name: 'accessToken',
      required: true,
    }),
    UseInterceptors(
      FilesInterceptor('images', 50, {
        limits: {
          fileSize: 1024 * 1024 * 50, //50MB
        },
        fileFilter(req, file, cb) {
          // /^.*\.(jpg|jpeg|png|gif|bmp|webp)$/i
          if (!file.mimetype.match('image/*')) {
            console.log('Cancel upload, file not support');
            // Block image upload in public/img folder
            cb(null, false);
          } else {
            cb(null, true);
          }
        },
      }),
    ),
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

export const deletePostsDecorator = () =>
  applyDecorators(
    ApiOperation({
      summary: 'Delete posts',
      description:
        'Delete multiple posts. Requires authentication and post ownership.',
    }),
    Roles([RolesLevel.ADMIN]),
  );

export const deletePostAsAdminDecorator = () =>
  applyDecorators(
    ApiOperation({
      summary: 'Delete post (Admin)',
      description: 'Delete any post with administrator-level access privileges',
    }),
    Roles([RolesLevel.ADMIN]),
  );

export const getPostCountDecorator = () =>
  applyDecorators(
    ApiOperation({
      summary: 'Get post count',
      description: 'Get the total number of posts',
    }),
  );

export const aiGenerateImagesDecorator = () =>
  applyDecorators(
    ApiOperation({
      summary: 'Generate AI images',
      description:
        'Generate images using AI technology. Authentication required.',
    }),
    ApiHeader({
      name: 'accessToken',
      required: true,
    }),
    ApiBody({
      type: GenerateImagesDto,
    }),
    UseGuards(JwtTokenVerifyGuard),
  );

export const getPriceGenerateImagesDecorator = () =>
  applyDecorators(
    ApiOperation({
      summary: 'Get price for generate images',
      description: 'Get the price for generate images',
    }),
    ApiBody({
      type: GenerateImagesDto,
    }),
  );
