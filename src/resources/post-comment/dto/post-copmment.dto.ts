import { ApiProperty, ApiPropertyOptional } from '@nestjs/swagger';
import {
  IsArray,
  IsNotEmpty,
  IsOptional,
  IsString,
  IsUUID,
} from 'class-validator';

export class CreatePostCommentDto {
  @ApiProperty({ default: '' })
  @IsString()
  @IsNotEmpty()
  content: string;

  @ApiPropertyOptional({ default: '' })
  @IsUUID()
  @IsOptional()
  replyToId?: string;

  @ApiPropertyOptional({
    type: 'array',
    items: { type: 'string' },
    description: 'Array of user IDs that are mentioned in the comment',
  })
  @IsArray()
  @IsUUID(4, { each: true })
  @IsOptional()
  mentionedUserIds?: string[];
}

export class UpdatePostCommentDto {
  @ApiPropertyOptional({ default: '', description: 'Content of the comment' })
  @IsString()
  @IsOptional()
  content?: string;
}

// export class UpdatePostCommentAdminDto extends UpdatePostCommentDto {
//   @ApiPropertyOptional({ default: '' })
//   @IsUUID()
//   @IsOptional()
//   replyToId?: string;

//   @ApiPropertyOptional({ default: 0 })
//   @IsNumber()
//   @IsOptional()
//   level?: number;

//   @ApiPropertyOptional({ default: 0 })
//   @IsNumber()
//   @IsOptional()
//   repliesCount?: number;

//   @ApiPropertyOptional({ default: '' })
//   @IsUUID()
//   @IsOptional()
//   authorId?: string;

//   @ApiPropertyOptional({ default: '' })
//   @IsUUID()
//   @IsOptional()
//   postId?: string;
// }
