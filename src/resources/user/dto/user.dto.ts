import { ApiProperty, ApiPropertyOptional } from '@nestjs/swagger';
import { Type } from 'class-transformer';
import {
  IsArray,
  IsBoolean,
  IsNotEmpty,
  IsNumber,
  IsObject,
  IsOptional,
  IsString,
} from 'class-validator';

export class UserAdditionalInfoDto {
  @ApiPropertyOptional({ default: '' })
  @IsString()
  @IsOptional()
  living: string;
  @ApiPropertyOptional({ default: '' })
  @IsString()
  @IsOptional()
  hometown: string;
  @ApiPropertyOptional({ default: '' })
  @IsString()
  @IsOptional()
  website: string;
  @ApiPropertyOptional({ default: [] })
  @IsArray()
  @IsOptional()
  jobs: string[];
  @ApiPropertyOptional({ default: '' })
  @IsString()
  @IsOptional()
  birthDate: string;
}

export class UpdateProfileDto {
  @ApiPropertyOptional({ default: '' })
  @IsString()
  @IsOptional()
  email: string;
  @ApiPropertyOptional({ default: '' })
  @IsString()
  @IsOptional()
  bio: string;
  @ApiPropertyOptional({ default: '' })
  @IsString()
  @IsOptional()
  password: string;
  @ApiPropertyOptional({ default: '' })
  @IsString()
  @IsOptional()
  fullName: string;
  @ApiPropertyOptional({ default: '' })
  @IsString()
  @IsOptional()
  displayName: string;
  @ApiPropertyOptional({ default: '' })
  @IsString()
  @IsOptional()
  phoneNumber: string;
  @ApiPropertyOptional({ default: 0 })
  @IsNumber()
  @IsOptional()
  age: number;
  @ApiPropertyOptional({
    type: UserAdditionalInfoDto,
    description: 'Additional information about the user',
  })
  @Type(() => UserAdditionalInfoDto)
  @IsObject()
  @IsOptional()
  additionalInfo: UserAdditionalInfoDto;
}

export class UpdateUserDto extends UpdateProfileDto {
  @ApiPropertyOptional({ default: '' })
  @IsString()
  @IsOptional()
  type: string;
  @ApiPropertyOptional({ default: false })
  @IsBoolean()
  @IsOptional()
  isActive: boolean;
  @ApiPropertyOptional({ default: false })
  @IsBoolean()
  @IsOptional()
  isVerified: boolean;
  @ApiPropertyOptional({ default: false })
  @IsBoolean()
  @IsOptional()
  isBanned: boolean;
}

export class BanUserDto {
  @ApiProperty({ default: false })
  @IsBoolean()
  @IsNotEmpty()
  isBanned: boolean;
}

export class UserAvatarUpdateDto {
  @ApiProperty({
    type: 'file',
    description: 'Max size : 5MB per file, Only Accept Image File',
    required: true,
  })
  file: Express.Multer.File;
}

export class UserCoverImageUpdateDto extends UserAvatarUpdateDto {}

export class UserCreditsUpdateDto {
  @ApiProperty({ default: 0 })
  @IsNumber()
  @IsNotEmpty()
  amount: number;
}
export class UserActiveByCodeDto {
  @ApiProperty({ default: '' })
  @IsString()
  @IsNotEmpty()
  verifyCode: string;
}

export class RefreshTokenDto {
  @ApiProperty({ default: '' })
  @IsString()
  @IsNotEmpty()
  accessToken: string;
}

export class RefreshTokenResponseDto {
  accessToken: string;
}
