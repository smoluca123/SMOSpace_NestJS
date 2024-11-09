import { ApiProperty } from '@nestjs/swagger';
import { IsBoolean, IsNumber, IsString } from 'class-validator';

export class UpdateProfileDto {
  @ApiProperty({ default: '' })
  @IsString()
  email: string;
  @ApiProperty({ default: '' })
  @IsString()
  password: string;
  @ApiProperty({ default: '' })
  @IsString()
  fullName: string;
  @ApiProperty({ default: '' })
  @IsString()
  displayName: string;
  @ApiProperty({ default: '' })
  @IsString()
  phoneNumber: string;
  @ApiProperty({ default: 0 })
  @IsNumber()
  age: number;
}

export class UpdateUserDto extends UpdateProfileDto {
  @ApiProperty({ default: '' })
  @IsString()
  type: string;
  @ApiProperty({ default: false })
  @IsBoolean()
  isActive: boolean;
  @ApiProperty({ default: false })
  @IsBoolean()
  isVerified: boolean;
  @ApiProperty({ default: false })
  @IsBoolean()
  isBanned: boolean;
}

export class BanUserDto {
  @ApiProperty({ default: false })
  @IsBoolean()
  isBanned: boolean;
}
