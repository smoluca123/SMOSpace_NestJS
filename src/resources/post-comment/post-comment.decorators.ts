import { applyDecorators, UseGuards } from '@nestjs/common';
import { ApiHeader, ApiOperation, ApiQuery } from '@nestjs/swagger';
import { ApiQueryLimitAndPage } from 'src/decorators/pagination.decorators';
import { Roles } from 'src/decorators/roles.decorator';
import { RolesLevel } from 'src/global/enums.global';
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
      description:
        'Create a new comment for a specific post. Requires authentication.',
    }),
  );

export const getPostCommentDecorator = () =>
  applyDecorators(
    ApiOperation({
      summary: 'Get post comments',
      description:
        'Retrieve all comments for a specific post with pagination support',
    }),
    ApiQueryLimitAndPage(),
    ApiQuery({
      name: 'replyTo',
      required: false,
      description: 'Filter comments that are replies to a specific comment ID',
    }),
  );

export const updatePostCommentDecorator = () =>
  applyDecorators(
    UseGuards(JwtTokenVerifyGuard),
    ApiOperation({
      summary: 'Update post comment',
      description: 'Update a specific post comment',
    }),
    ApiHeader({
      name: 'accessToken',
      required: true,
    }),
  );

export const updatePostCommentByAdminDecorator = () =>
  applyDecorators(
    Roles([RolesLevel.MANAGER]),
    ApiOperation({
      summary: 'Update post comment by admin',
      description: 'Update a specific post comment by admin',
    }),
  );

export const deletePostCommentDecorator = () =>
  applyDecorators(
    UseGuards(JwtTokenVerifyGuard),
    ApiHeader({
      name: 'accessToken',
      required: true,
    }),
    ApiOperation({
      summary: 'Delete post comment',
      description: 'Delete a specific post comment',
    }),
  );

export const deletePostCommentByAdminDecorator = () =>
  applyDecorators(
    Roles([RolesLevel.MANAGER]),
    ApiOperation({
      summary: 'Delete post comment by admin',
      description: 'Delete a specific post comment by admin',
    }),
  );

export const getCommentCountDecorator = () =>
  applyDecorators(
    Roles([RolesLevel.MANAGER]),
    ApiOperation({
      summary: 'Get comment count',
    }),
  );

export const likeCommentDecorator = () =>
  applyDecorators(
    UseGuards(JwtTokenVerifyGuard),
    ApiOperation({
      summary: 'Toggle / change comment reaction',
      description:
        'Toggle the current user reaction on a comment. Pass `type` in the body to react with a specific emoji (LOVE, HAHA, ...). Re-sending the same type toggles the reaction off.',
    }),
    ApiHeader({
      name: 'accessToken',
      required: true,
    }),
  );

export const getCommentLikesDecorator = () =>
  applyDecorators(
    ApiOperation({
      summary: 'Get comment likes',
      description:
        'Retrieve a paginated list of users who reacted to the specified comment. Optional `type` filters by reaction.',
    }),
    ApiQueryLimitAndPage(),
    ApiQuery({
      name: 'userId',
      required: false,
      description: 'Filter to check if the comment is liked by this user',
    }),
    ApiQuery({
      name: 'type',
      required: false,
      description: 'Filter likes by reaction type (LIKE, LOVE, HAHA, ...)',
    }),
  );
