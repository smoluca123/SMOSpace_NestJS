import { ApiProperty } from '@nestjs/swagger';
import { IsBoolean, IsNotEmpty, IsNumber, IsString } from 'class-validator';

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
