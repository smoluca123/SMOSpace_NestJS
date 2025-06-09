import {
  Controller,
  Get,
  Param,
  Patch,
  Query,
  UseGuards,
  Body,
} from '@nestjs/common';
import { NotificationService } from './notification.service';
import { normalizePaginationParams } from 'src/utils/utils';
import { ApiBearerAuth, ApiTags } from '@nestjs/swagger';
import { AuthGuard } from '@nestjs/passport';
import {
  changeNotificationStatusDecorator,
  getNotificationsDecorator,
  getUserNotificationsDecorator,
} from 'src/resources/notification/notification.decorators';
import { DecodedAccessToken } from 'src/decorators/decodedAccessToken.decorator';
import { IDecodedAccecssTokenType } from 'src/interfaces/interfaces.global';
import { ChangeNotificationStatusDto } from 'src/resources/notification/notification.dto';

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

  @Patch('/status/:notificationId')
  @changeNotificationStatusDecorator()
  async changeNotificationStatus(
    @Param('notificationId') notificationId: string,
    @Body() data: ChangeNotificationStatusDto,
  ) {
    return this.notificationService.changeNotificationStatus({
      notificationId,
      isRead: data.isRead,
    });
  }
}
