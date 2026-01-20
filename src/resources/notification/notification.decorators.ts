import { applyDecorators, UseGuards } from '@nestjs/common';
import {
  ApiBody,
  ApiHeader,
  ApiOperation,
  ApiParam,
  ApiQuery,
} from '@nestjs/swagger';
import { ApiQueryLimitAndPage } from 'src/decorators/pagination.decorators';
import { JwtTokenVerifyGuard } from 'src/guards/jwt-token-verify.guard';
import {
  ChangeNotificationStatusDto,
  MarkGroupAsReadDto,
} from 'src/resources/notification/notification.dto';

export const getUserNotificationsDecorator = () =>
  applyDecorators(
    ApiOperation({
      summary: 'Get notifications',
      description: 'Get notifications',
    }),
    ApiParam({
      name: 'userId',
      description: 'User ID',
    }),
    ApiQueryLimitAndPage(),
  );

export const getNotificationsDecorator = () =>
  applyDecorators(
    ApiOperation({
      summary: 'Get notifications',
      description: 'Get notifications',
    }),
    UseGuards(JwtTokenVerifyGuard),
    ApiHeader({
      name: 'accessToken',
      required: true,
      description: 'Access token',
    }),
    ApiQueryLimitAndPage(),
  );

export const getGroupedNotificationsDecorator = () =>
  applyDecorators(
    ApiOperation({
      summary: 'Get grouped notifications',
      description: 'Get notifications grouped by type, entity, and time window',
    }),
    UseGuards(JwtTokenVerifyGuard),
    ApiHeader({
      name: 'accessToken',
      required: true,
      description: 'Access token',
    }),
    ApiQueryLimitAndPage(),
    ApiQuery({
      name: 'groupByTime',
      required: false,
      description: 'Group notifications within this time range (hours)',
      example: 24,
    }),
  );

export const changeNotificationStatusDecorator = () =>
  applyDecorators(
    ApiOperation({
      summary: 'Change notification status',
      description: 'Change notification read status',
    }),
    ApiParam({
      name: 'notificationId',
      description: 'Notification ID',
    }),
    UseGuards(JwtTokenVerifyGuard),
    ApiHeader({
      name: 'accessToken',
      required: true,
      description: 'Access token',
    }),
    ApiBody({
      type: ChangeNotificationStatusDto,
    }),
  );

export const markGroupAsReadDecorator = () =>
  applyDecorators(
    ApiOperation({
      summary: 'Mark grouped notifications as read',
      description: 'Mark all notifications in a group as read/unread',
    }),
    UseGuards(JwtTokenVerifyGuard),
    ApiHeader({
      name: 'accessToken',
      required: true,
      description: 'Access token',
    }),
    ApiBody({
      type: MarkGroupAsReadDto,
    }),
  );
