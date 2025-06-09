import { applyDecorators, UseGuards } from '@nestjs/common';
import { ApiBody, ApiHeader, ApiOperation, ApiParam } from '@nestjs/swagger';
import { ApiQueryLimitAndPage } from 'src/decorators/pagination.decorators';
import { JwtTokenVerifyGuard } from 'src/guards/jwt-token-verify.guard';
import { ChangeNotificationStatusDto } from 'src/resources/notification/notification.dto';

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
