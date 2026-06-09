import { ApiProperty } from '@nestjs/swagger';
import {
  IsArray,
  IsBoolean,
  IsEnum,
  IsIn,
  IsNotEmpty,
  IsNumber,
  IsOptional,
  IsString,
  IsUUID,
  Max,
  Min,
} from 'class-validator';
import { Transform } from 'class-transformer';
import { UUID } from 'crypto';
import { ReactionType } from '@prisma/client';

export class CreatePostDto {
  @ApiProperty({ default: '', required: true })
  @IsString()
  @IsNotEmpty()
  content: string;

  @ApiProperty({ default: 'false' })
  @IsBoolean()
  @Transform(({ value }) => {
    if (typeof value === 'string') {
      return value.toLowerCase() === 'true';
    }
    return Boolean(value);
  })
  isPrivate: boolean;

  @ApiProperty({ type: 'array', items: { type: 'string', format: 'binary' } })
  @IsArray()
  @IsOptional()
  images: Express.Multer.File[];

  @ApiProperty({
    type: 'array',
    items: { type: 'string' },
    description: 'Array of user IDs that are mentioned in the post',
    required: false,
  })
  @Transform(({ value }) => {
    // Parse JSON string from FormData
    if (typeof value === 'string') {
      try {
        return JSON.parse(value);
      } catch {
        return [];
      }
    }
    return value;
  })
  @IsArray()
  @IsUUID(4, { each: true })
  @IsOptional()
  mentionedUserIds?: string[];
}

export class UpdatePostDto {
  @ApiProperty({ default: '' })
  @IsString()
  content: string;

  @ApiProperty({ default: 'false' })
  @Transform(({ value }) => {
    if (typeof value === 'string') {
      return value.toLowerCase() === 'true';
    }
    return Boolean(value);
  })
  @IsBoolean()
  isPrivate: boolean;

  @ApiProperty({
    type: 'array',
    items: { type: 'string' },
    description: 'Array of user IDs that are mentioned in the post',
    required: false,
  })
  @Transform(({ value }) => {
    // Parse JSON string from FormData
    if (typeof value === 'string') {
      try {
        return JSON.parse(value);
      } catch {
        return [];
      }
    }
    return value;
  })
  @IsArray()
  @IsUUID(4, { each: true })
  @IsOptional()
  mentionedUserIds?: string[];
}

export class UpdatePostAsAdminDto extends UpdatePostDto {
  @ApiProperty({ default: '' })
  @IsUUID()
  authorId: string;
}

export class DeletePostsDto {
  @ApiProperty()
  @IsNotEmpty()
  @IsArray()
  @IsUUID(4, { each: true })
  postIds: UUID[];
}

export class GenerateImagesDto {
  @ApiProperty({ default: '' })
  @IsString()
  @IsNotEmpty()
  prompt: string;

  @ApiProperty({ default: 1 })
  @IsNumber()
  @Min(1)
  @Max(4)
  @IsNotEmpty()
  numImages: number;

  @ApiProperty({
    default: '1024x1024',
    enum: ['1024x1024', '1344x768', '1280x960', '960x1280', '768x1344'],
  })
  @IsString()
  @IsIn(['1024x1024', '1344x768', '1280x960', '960x1280', '768x1344'])
  @IsNotEmpty()
  imageSize: string;

  @ApiProperty({
    default: -1,
    description: 'Seed for the images, -1 for random seed',
  })
  @IsNumber()
  @Min(-1)
  @Max(2147483647)
  seed: number;

  @ApiProperty({
    default: 0,
    description: 'The number of inference steps to perform',
  })
  @IsNumber()
  @Min(1)
  @Max(60)
  @IsNotEmpty()
  steps: number;
}

/**
 * Body for `POST /post/share/:postId`. Both fields are optional - an empty
 * body shares the post with no caption, publicly.
 */
export class SharePostDto {
  @ApiProperty({
    default: '',
    required: false,
    description: 'Optional caption added on top of the shared post',
  })
  @IsString()
  @IsOptional()
  content?: string;

  @ApiProperty({ default: false, required: false })
  @Transform(({ value }) => {
    if (typeof value === 'string') {
      return value.toLowerCase() === 'true';
    }
    return Boolean(value);
  })
  @IsBoolean()
  @IsOptional()
  isPrivate?: boolean;

  @ApiProperty({
    type: 'array',
    items: { type: 'string' },
    description: 'Array of user IDs mentioned in the share caption',
    required: false,
  })
  @Transform(({ value }) => {
    if (typeof value === 'string') {
      try {
        return JSON.parse(value);
      } catch {
        return [];
      }
    }
    return value;
  })
  @IsArray()
  @IsUUID(4, { each: true })
  @IsOptional()
  mentionedUserIds?: string[];
}

/**
 * Body for `POST /post/like/:postId`. The `type` field is optional to keep
 * backward compatibility with clients that just want a "Like" toggle - it
 * defaults to LIKE on the server.
 */
export class ReactPostDto {
  @ApiProperty({
    enum: ReactionType,
    required: false,
    default: ReactionType.LIKE,
    description:
      'Reaction type. Omit (or pass LIKE) for the classic Like behavior.',
  })
  @IsOptional()
  @IsEnum(ReactionType)
  type?: ReactionType;
}
