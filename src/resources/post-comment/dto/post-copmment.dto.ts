import { ApiProperty, ApiPropertyOptional } from '@nestjs/swagger';
import { IsNotEmpty, IsOptional, IsString } from 'class-validator';

export class CreatePostCommentDto {
  @ApiProperty({ default: '' })
  @IsString()
  @IsNotEmpty()
  content: string;

  @ApiPropertyOptional({ default: '', required: false })
  @IsString()
  @IsOptional()
  replyToId?: string;
}
