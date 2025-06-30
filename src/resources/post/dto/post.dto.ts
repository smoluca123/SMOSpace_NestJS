import { ApiProperty } from '@nestjs/swagger';
import {
  IsArray,
  IsBoolean,
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
