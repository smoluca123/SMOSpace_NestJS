import { ApiProperty } from '@nestjs/swagger';
import { IsBoolean } from 'class-validator';

export class ChangeNotificationStatusDto {
  @ApiProperty({
    description: 'Is read',
    example: true,
  })
  @IsBoolean()
  isRead: boolean;
}
