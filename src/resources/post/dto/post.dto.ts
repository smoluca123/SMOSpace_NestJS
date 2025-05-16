import { ApiProperty } from '@nestjs/swagger';
import {
  IsArray,
  IsBoolean,
  IsNotEmpty,
  IsOptional,
  IsString,
  IsUUID,
} from 'class-validator';
import { Transform } from 'class-transformer';

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
