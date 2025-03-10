import { Controller, Get, Param, Query, UseGuards } from '@nestjs/common';
import { NotificationService } from './notification.service';
import { normalizePaginationParams } from 'src/utils/utils';
import { ApiBearerAuth, ApiTags } from '@nestjs/swagger';
import { AuthGuard } from '@nestjs/passport';
import {
  getNotificationsDecorator,
  getUserNotificationsDecorator,
} from 'src/resources/notification/notification.decorators';
import { DecodedAccessToken } from 'src/decorators/decodedAccessToken.decorator';
import { IDecodedAccecssTokenType } from 'src/interfaces/interfaces.global';

@ApiTags('Notification Management')
@ApiBearerAuth()
@UseGuards(AuthGuard('jwt'))
@Controller('notification')
export class NotificationController {
  constructor(private readonly notificationService: NotificationService) {}

  @Get(':userId')
  @getUserNotificationsDecorator()
  async getUserNotifications(
    @Param('userId') userId: string,
    @Query('page') pageParam?: string,
    @Query('limit') limitParam?: string,
  ) {
    const { page, limit } = normalizePaginationParams({
      page: Number(pageParam),
      limit: Number(limitParam),
    });

    return this.notificationService.getNotifications({
      userId,
      page,
      limit,
    });
  }

  @Get('/')
  @getNotificationsDecorator()
  async getNotifications(
    @DecodedAccessToken() decodedAccessToken: IDecodedAccecssTokenType,
    @Query('page') pageParam?: string,
    @Query('limit') limitParam?: string,
  ) {
    const { page, limit } = normalizePaginationParams({
      page: Number(pageParam),
      limit: Number(limitParam),
    });

    return this.notificationService.getNotifications({
      userId: decodedAccessToken.userId,
      page,
      limit,
    });
  }
}
