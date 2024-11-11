import { ApiProperty } from '@nestjs/swagger';
import { IsBoolean, IsNotEmpty, IsString } from 'class-validator';

export class CreatePostDto {
  @ApiProperty({ default: '', required: true })
  @IsString()
  @IsNotEmpty()
  content: string;

  @ApiProperty({ default: false })
  @IsBoolean()
  isPrivate: boolean;
}
