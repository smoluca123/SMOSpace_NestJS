import { ApiProperty } from '@nestjs/swagger';
import {
  EntityType,
  NotificationPriority,
  NotificationType_Type,
} from '@prisma/client';
import {
  IsBoolean,
  IsNumber,
  IsOptional,
  IsString,
  Min,
} from 'class-validator';
import { Type } from 'class-transformer';

// ==================== REQUEST DTOs ====================

export class GetGroupedNotificationsQueryDto {
  @ApiProperty({
    description: 'Page number',
    example: 1,
    required: false,
  })
  @IsOptional()
  @Type(() => Number)
  @IsNumber()
  @Min(1)
  page?: number;

  @ApiProperty({
    description: 'Number of items per page',
    example: 10,
    required: false,
  })
  @IsOptional()
  @Type(() => Number)
  @IsNumber()
  @Min(1)
  limit?: number;

  @ApiProperty({
    description: 'Group notifications within this time range (hours)',
    example: 24,
    required: false,
  })
  @IsOptional()
  @Type(() => Number)
  @IsNumber()
  @Min(1)
  groupByTime?: number;
}

export class MarkGroupAsReadDto {
  @ApiProperty({
    description: 'Notification IDs in the group',
    example: ['uuid1', 'uuid2'],
    type: [String],
  })
  @IsString({ each: true })
  notificationIds: string[];

  @ApiProperty({
    description: 'Mark as read or unread',
    example: true,
  })
  @IsBoolean()
  isRead: boolean;
}

// ==================== RESPONSE DTOs ====================

export class SenderSummaryDto {
  @ApiProperty({ description: 'Sender ID' })
  id: string;

  @ApiProperty({ description: 'Sender username' })
  username: string;

  @ApiProperty({ description: 'Sender full name' })
  fullName: string;

  @ApiProperty({ description: 'Sender avatar URL', nullable: true })
  avatar: string | null;
}

export class NotificationTypeDto {
  @ApiProperty({ description: 'Notification type ID' })
  id: string;

  @ApiProperty({
    description: 'Notification type',
    enum: NotificationType_Type,
  })
  type: NotificationType_Type;
}

export class NotificationContentDto {
  @ApiProperty({ description: 'Notification title' })
  title: string;

  @ApiProperty({ description: 'Notification message' })
  message: string;
}

export class GroupedNotificationDto {
  @ApiProperty({ description: 'Unique group key' })
  groupKey: string;

  @ApiProperty({ description: 'Notification type info' })
  type: NotificationTypeDto;

  @ApiProperty({ description: 'Entity type', enum: EntityType, nullable: true })
  entityType: EntityType | null;

  @ApiProperty({
    description: 'Target entity ID (e.g., postId)',
    nullable: true,
  })
  entityId: string | null;

  @ApiProperty({ description: 'Number of notifications in group' })
  count: number;

  @ApiProperty({
    description: 'List of senders (max 3)',
    type: [SenderSummaryDto],
  })
  senders: SenderSummaryDto[];

  @ApiProperty({ description: 'Content from latest notification' })
  content: NotificationContentDto;

  @ApiProperty({ description: 'Metadata from latest notification' })
  metadata: Record<string, unknown>;

  @ApiProperty({
    description: 'Priority of the group',
    enum: NotificationPriority,
  })
  priority: NotificationPriority;

  @ApiProperty({ description: 'Timestamp of the latest notification' })
  createdAt: Date;

  @ApiProperty({ description: 'True if ALL notifications in group are read' })
  isRead: boolean;

  @ApiProperty({
    description: 'All notification IDs in this group',
    type: [String],
  })
  notificationIds: string[];
}
