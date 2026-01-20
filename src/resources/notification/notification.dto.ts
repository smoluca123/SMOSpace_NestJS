import { ApiProperty } from '@nestjs/swagger';
import { IsArray, IsBoolean, IsString } from 'class-validator';

export class ChangeNotificationStatusDto {
  @ApiProperty({
    description: 'Is read',
    example: true,
  })
  @IsBoolean()
  isRead: boolean;
}

export class MarkGroupAsReadDto {
  @ApiProperty({
    description: 'Notification IDs in the group',
    example: ['uuid1', 'uuid2'],
    type: [String],
  })
  @IsArray()
  @IsString({ each: true })
  notificationIds: string[];

  @ApiProperty({
    description: 'Mark as read or unread',
    example: true,
  })
  @IsBoolean()
  isRead: boolean;
}
