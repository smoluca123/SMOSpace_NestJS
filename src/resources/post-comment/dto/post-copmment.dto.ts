import { ApiProperty, ApiPropertyOptional } from '@nestjs/swagger';
import { ReactionType } from '@prisma/client';
import {
  IsArray,
  IsEnum,
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

/**
 * Body for `POST /post/comment/like/:commentId`. The `type` field is optional
 * so legacy clients sending an empty body still get the classic LIKE toggle
 * (server-side default).
 */
export class ReactCommentDto {
  @ApiPropertyOptional({
    enum: ReactionType,
    required: false,
    description: 'Reaction type. Defaults to LIKE when omitted.',
  })
  @IsEnum(ReactionType)
  @IsOptional()
  type?: ReactionType;
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
