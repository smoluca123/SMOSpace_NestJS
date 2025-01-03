import { applyDecorators, UseGuards, UseInterceptors } from '@nestjs/common';
import { FileInterceptor } from '@nestjs/platform-express';
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
import { JwtTokenVerifyGuard } from 'src/guards/jwt-token-verify.guard';
import { RolesLevel } from 'src/interfaces/interfaces.global';

import { UserAvatarUpdateDto } from 'src/resources/user/dto/user.dto';

export const getAllUsersDecorator = () =>
  applyDecorators(
    ApiOperation({
      summary: 'Get all users with pagination',
      description:
        'Retrieve a paginated list of users with optional search by keywords',
    }),
    ApiQueryLimitAndPage(),
    ApiQuery({
      name: 'keywords',
      required: false,
      description:
        'Search users by username, email, full name, or display name',
    }),
    ApiQuery({
      name: 'followerId',
      required: false,
      description: 'Optional follower ID (user ID) to check follow status',
    }),
  );

export const getInformationDecorator = () =>
  applyDecorators(
    UseGuards(JwtTokenVerifyGuard),
    ApiOperation({
      summary: 'Get current user profile',
      description: 'Retrieve the profile information of the authenticated user',
    }),
    ApiHeader({
      name: 'accessToken',
      required: true,
      description: 'JWT access token for authentication',
    }),
  );

export const getUserInformationDecorator = () =>
  applyDecorators(
    Roles([RolesLevel.MANAGER]),
    ApiOperation({
      summary: 'Get user profile by ID',
      description:
        "Retrieve a specific user's profile information (Manager access required)",
    }),
    ApiParam({
      name: 'userId',
      description: 'User ID or username to retrieve',
    }),
    ApiQuery({
      name: 'followerId',
      required: false,
      description:
        'Optional follower ID to check if this user follows the target user',
    }),
  );

export const banUserDecorator = () =>
  applyDecorators(
    Roles([RolesLevel.ADMIN]),
    ApiOperation({
      summary: 'Ban/unban user',
      description:
        'Toggle ban status for a specific user (Admin access required)',
    }),
  );

export const updateInformationDecorator = () =>
  applyDecorators(
    ApiOperation({
      summary: 'Update current user profile',
      description: "Update the authenticated user's profile information",
    }),
    ApiHeader({
      name: 'accessToken',
      required: true,
      description: 'JWT access token for authentication',
    }),
    UseGuards(JwtTokenVerifyGuard),
  );

export const updateUserInformationDecorator = () =>
  applyDecorators(
    ApiOperation({
      summary: 'Update user profile by ID',
      description: "Update a specific user's profile information",
    }),
  );

export const updateUserAvatarDecorator = () =>
  applyDecorators(
    ApiOperation({
      summary: 'Update user avatar',
      description: "Upload and update a user's profile picture",
    }),
    ApiConsumes('multipart/form-data'),
    ApiParam({
      name: 'userId',
      description: 'ID of the user whose avatar will be updated',
    }),
    ApiBody({
      type: UserAvatarUpdateDto,
      description: 'Avatar image file (max 50MB, image files only)',
    }),
    UseInterceptors(
      FileInterceptor('file', {
        // storage: multer.memoryStorage(),
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

export const followUserDecorator = () =>
  applyDecorators(
    ApiOperation({
      summary: 'Follow/unfollow user',
      description: 'Toggle follow status for a specific user',
    }),
    ApiHeader({
      name: 'accessToken',
      required: true,
      description: 'JWT access token for authentication',
    }),
    ApiParam({
      name: 'userId',
      description: 'ID of the user to follow/unfollow',
    }),
    UseGuards(JwtTokenVerifyGuard),
  );

export const getFollowersDecorator = () =>
  applyDecorators(
    ApiOperation({
      summary: 'Get followers of a user',
      description: 'Retrieve the followers of a specific user',
    }),
    ApiParam({
      name: 'userId',
      description: 'ID of the user whose followers will be retrieved',
    }),
    ApiQueryLimitAndPage(),
  );
