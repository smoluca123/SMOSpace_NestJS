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
import { FILE_VALIDATION } from 'src/constants/file.constants';
import { ApiQueryLimitAndPage } from 'src/decorators/pagination.decorators';
import { Roles } from 'src/decorators/roles.decorator';
import { JwtTokenVerifyGuard } from 'src/guards/jwt-token-verify.guard';
import { FileUploadInterceptor } from 'src/interceptors/file-upload.interceptor';
import { RolesLevel } from 'src/interfaces/interfaces.global';

import {
  BanUsersDto,
  ChangeFriendshipStatusDto,
  CreateUserDto,
  UserAvatarUpdateDto,
  UserCoverImageUpdateDto,
} from 'src/resources/user/dto/user.dto';

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
      name: 'currentUserId',
      required: false,
      description:
        'Optional current user ID (user ID) to check follow, friend status',
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
      name: 'currentUserId',
      required: false,
      description:
        'Optional current user ID to check if this user follows the target user',
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

export const banUsersDecorator = () =>
  applyDecorators(
    Roles([RolesLevel.ADMIN]),
    ApiOperation({
      summary: 'Ban/unban users',
      description:
        'Toggle ban status for multiple users (Admin access required)',
    }),
    ApiBody({
      type: BanUsersDto,
      description: 'List of users to ban/unban',
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

export const updateUserCoverImageDecorator = () =>
  applyDecorators(
    ApiOperation({
      summary: 'Update user cover image',
      description: "Upload and update a user's cover image",
    }),
    ApiConsumes('multipart/form-data'),
    ApiParam({
      name: 'userId',
      description: 'ID of the user whose cover image will be updated',
    }),
    ApiBody({
      type: UserCoverImageUpdateDto,
      description: 'Cover image file (max 5MB, image files only)',
    }),
    UseInterceptors(
      FileInterceptor('file', {
        // limits: {
        //   fileSize: 1024 * 1024 * 5, //5MB
        // },
        // fileFilter(req, file, cb) {
        //   if (!file.mimetype.match('image/*')) {
        //     cb(null, false);
        //   } else {
        //     cb(null, true);
        //   }
        // },
      }),
      new FileUploadInterceptor({
        maxSize: FILE_VALIDATION.IMAGE.MAX_SIZE,
        allowedMimeTypes: [...FILE_VALIDATION.IMAGE.ALLOWED_TYPES],
      }),
    ),
  );

export const followUserDecorator = () =>
  applyDecorators(
    ApiOperation({
      summary: 'Follow user',
      description: 'Follow a specific user',
    }),
    ApiHeader({
      name: 'accessToken',
      required: true,
      description: 'JWT access token for authentication',
    }),
    ApiParam({
      name: 'userId',
      description: 'ID of the user to follow',
    }),
    UseGuards(JwtTokenVerifyGuard),
  );

export const unFollowUserDecorator = () =>
  applyDecorators(
    ApiOperation({
      summary: 'Unfollow user',
      description: 'Unfollow a specific user',
    }),
    ApiHeader({
      name: 'accessToken',
      required: true,
      description: 'JWT access token for authentication',
    }),
    ApiParam({
      name: 'userId',
      description: 'ID of the user to unfollow',
    }),
    UseGuards(JwtTokenVerifyGuard),
  );

export const getFollowersByIdDecorator = () =>
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
    ApiQuery({
      name: 'followerId',
      required: false,
      description:
        'Optional follower ID to check if this user follows the target user',
    }),
  );

export const getFollowersDecorator = () =>
  applyDecorators(
    ApiOperation({
      summary: 'Get followers of current user',
      description: 'Retrieve the followers of the authenticated user',
    }),
    ApiHeader({
      name: 'accessToken',
      required: true,
      description: 'JWT access token for authentication',
    }),
    UseGuards(JwtTokenVerifyGuard),
    ApiQueryLimitAndPage(),
  );

export const getFollowingsByIdDecorator = () =>
  applyDecorators(
    ApiOperation({
      summary: 'Get followings of a user',
      description: 'Retrieve the followings of a specific user',
    }),
    ApiParam({
      name: 'userId',
      description: 'ID of the user whose followings will be retrieved',
    }),
    ApiQueryLimitAndPage(),
  );
export const getFollowingsDecorator = () =>
  applyDecorators(
    ApiOperation({
      summary: 'Get followings of current user',
      description: 'Retrieve the followings of the authenticated user',
    }),
    ApiHeader({
      name: 'accessToken',
      required: true,
      description: 'JWT access token for authentication',
    }),
    UseGuards(JwtTokenVerifyGuard),
    ApiQueryLimitAndPage(),
  );

export const getMyFriendListDecorator = () =>
  applyDecorators(
    ApiOperation({
      summary: 'Get friends of current user',
      description: 'Retrieve the friends of the authenticated user',
    }),
    ApiHeader({
      name: 'accessToken',
      required: true,
      description: 'JWT access token for authentication',
    }),
    UseGuards(JwtTokenVerifyGuard),
    ApiQueryLimitAndPage(),
  );
export const getFriendListDecorator = () =>
  applyDecorators(
    ApiOperation({
      summary: 'Get friends of current user',
      description: 'Retrieve the friends of the authenticated user',
    }),
    ApiParam({
      name: 'userId',
      description: 'ID of the user whose friends will be retrieved',
    }),
    ApiQueryLimitAndPage(),
  );

export const getFriendByUserIdDecorator = () =>
  applyDecorators(
    ApiOperation({
      summary: 'Get friend of current user',
      description: 'Retrieve the friend of the authenticated user',
    }),
    ApiHeader({
      name: 'accessToken',
      required: true,
      description: 'JWT access token for authentication',
    }),
    UseGuards(JwtTokenVerifyGuard),
    ApiParam({
      name: 'userId',
      description: 'ID of the user whose friend will be retrieved',
    }),
  );

export const getPendingFriendsRequestDecorator = () =>
  applyDecorators(
    ApiOperation({
      summary: 'Get pending friends of current user',
      description: 'Retrieve the pending friends of the authenticated user',
    }),
    ApiHeader({
      name: 'accessToken',
      required: true,
      description: 'JWT access token for authentication',
    }),
    UseGuards(JwtTokenVerifyGuard),
    ApiQueryLimitAndPage(),
  );

export const toggleFriendshipRequestDecorator = () =>
  applyDecorators(
    ApiOperation({
      summary: 'Toggle friendship request',
      description: 'Toggle friendship request for a specific user',
    }),
    ApiHeader({
      name: 'accessToken',
      required: true,
      description: 'JWT access token for authentication',
    }),
    UseGuards(JwtTokenVerifyGuard),
  );

export const changeFriendshipStatusDecorator = () =>
  applyDecorators(
    ApiOperation({
      summary: 'Change friendship status',
      description: 'Change friendship status for a specific user',
    }),
    ApiHeader({
      name: 'accessToken',
      required: true,
      description: 'JWT access token for authentication',
    }),
    UseGuards(JwtTokenVerifyGuard),
    ApiBody({
      type: ChangeFriendshipStatusDto,
      description: 'Friendship status to change',
    }),
  );

export const acceptFriendshipRequestDecorator = () =>
  applyDecorators(
    ApiOperation({
      summary: 'Accept friendship request',
      description: 'Accept friendship request for a specific user',
    }),
    ApiHeader({
      name: 'accessToken',
      required: true,
      description: 'JWT access token for authentication',
    }),
    UseGuards(JwtTokenVerifyGuard),
  );

export const toggleBlockFriendDecorator = () =>
  applyDecorators(
    ApiOperation({
      summary: 'Toggle block friend',
      description: 'Toggle block friend for a specific user',
    }),
    ApiHeader({
      name: 'accessToken',
      required: true,
      description: 'JWT access token for authentication',
    }),
    UseGuards(JwtTokenVerifyGuard),
  );

export const removeFriendDecorator = () =>
  applyDecorators(
    ApiOperation({
      summary: 'Remove friend',
      description: 'Remove friend for a specific user',
    }),
    ApiHeader({
      name: 'accessToken',
      required: true,
      description: 'JWT access token for authentication',
    }),
    UseGuards(JwtTokenVerifyGuard),
  );

export const getUserCountDecorator = () =>
  applyDecorators(
    ApiOperation({
      summary: 'Get user count',
      description: 'Get user count',
    }),
  );

export const adminCreateUserDecorator = () =>
  applyDecorators(
    ApiOperation({
      summary: 'Create a user',
      description: 'Create a user in the database',
    }),
    ApiBody({
      type: CreateUserDto,
      description: 'User data to create',
    }),
    Roles([RolesLevel.ADMIN]),
  );

export const getUserTypesDecorator = () =>
  applyDecorators(
    ApiOperation({
      summary: 'Get all user types',
      description: 'Get all user types from the database',
    }),
  );

export const getUserTypeByIdDecorator = () =>
  applyDecorators(
    ApiOperation({
      summary: 'Get user type by ID',
      description: 'Get user type by ID from the database',
    }),
    ApiParam({
      name: 'typeId',
      description: 'ID of the user type to retrieve',
    }),
  );
