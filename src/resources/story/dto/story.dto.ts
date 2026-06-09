import { ApiProperty, ApiPropertyOptional } from '@nestjs/swagger';
import { MediaType } from '@prisma/client';
import { Type } from 'class-transformer';
import {
  IsEnum,
  IsInt,
  IsNumber,
  IsOptional,
  IsString,
  Min,
  ValidateNested,
} from 'class-validator';

/** Request a presigned upload (direct-to-Storj). */
export class PresignStoryDto {
  @ApiProperty({ description: 'Original file name' })
  @IsString()
  filename: string;

  @ApiProperty({ description: 'MIME type, e.g. image/jpeg or video/mp4' })
  @IsString()
  contentType: string;

  @ApiProperty({ description: 'File size in bytes' })
  @IsInt()
  @Min(1)
  size: number;
}

export class UploadedPartDto {
  @ApiProperty()
  @IsInt()
  @Min(1)
  partNumber: number;

  @ApiProperty({ description: 'ETag returned by the part upload' })
  @IsString()
  etag: string;
}

/** Finalize a multipart upload. */
export class CompleteStoryUploadDto {
  @ApiProperty()
  @IsString()
  key: string;

  @ApiProperty()
  @IsString()
  uploadId: string;

  @ApiProperty({ type: [UploadedPartDto] })
  @ValidateNested({ each: true })
  @Type(() => UploadedPartDto)
  parts: UploadedPartDto[];
}

/** Create the story record after the media is uploaded to Storj. */
export class CreateStoryDto {
  @ApiProperty({ description: 'Object key returned by the presign step' })
  @IsString()
  key: string;

  @ApiProperty({ enum: MediaType })
  @IsEnum(MediaType)
  type: MediaType;

  @ApiPropertyOptional({ description: 'Video duration in seconds' })
  @IsNumber()
  @IsOptional()
  duration?: number;
}
