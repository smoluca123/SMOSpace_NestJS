import { Controller, Get, Param, Query, UseGuards } from '@nestjs/common';
import { NotificationService } from './notification.service';
import { normalizePaginationParams } from 'src/utils/utils';
import { ApiBearerAuth, ApiTags } from '@nestjs/swagger';
import { AuthGuard } from '@nestjs/passport';

@ApiTags('Notification Management')
@ApiBearerAuth()
@UseGuards(AuthGuard('jwt'))
@Controller('notification')
export class NotificationController {
  constructor(private readonly notificationService: NotificationService) {}

  @Get(':userId')
  async getNotifications(
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
}
