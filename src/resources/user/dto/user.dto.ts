import { ApiProperty, ApiPropertyOptional } from '@nestjs/swagger';
import { FriendStatus } from '@prisma/client';
import { Type } from 'class-transformer';
import {
  IsArray,
  IsBoolean,
  IsDate,
  IsIn,
  IsNotEmpty,
  IsNumber,
  IsObject,
  IsOptional,
  IsString,
  IsUUID,
} from 'class-validator';
import { UUID } from 'crypto';
import { UserRegisterDto } from 'src/resources/auth/dto/UserRegister.dto';

export class UserAdditionalInfoDto {
  @ApiPropertyOptional({ default: '' })
  @IsString()
  @IsOptional()
  living: string;
  @ApiPropertyOptional({ default: '' })
  @IsString()
  @IsOptional()
  hometown: string;
  @ApiPropertyOptional({ default: [] })
  @IsArray()
  @IsOptional()
  websites: string[];
  @ApiPropertyOptional({ default: [] })
  @IsArray()
  @IsOptional()
  jobs: string[];
  @ApiPropertyOptional({ default: '' })
  @IsDate()
  @IsOptional()
  birthDate: Date;
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

export class UserResetPasswordDto {
  @ApiProperty({ default: '' })
  @IsString()
  @IsNotEmpty()
  verifyCode: string;
  @ApiProperty({ default: '' })
  @IsString()
  @IsNotEmpty()
  password: string;
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

export type AllowedFriendStatus = Exclude<FriendStatus, 'PENDING' | 'BLOCKED'>;
export class ChangeFriendshipStatusDto {
  @ApiProperty({ default: FriendStatus.ACCEPTED })
  @IsIn([FriendStatus.REJECTED, FriendStatus.ACCEPTED])
  @IsNotEmpty()
  status: AllowedFriendStatus;
}

export class BanUsersDto {
  @ApiProperty({
    default: [
      {
        userId: '123e4567-e89b-12d3-a456-426614174000',
        isBanned: true,
      },
    ],
  })
  @IsArray()
  @IsNotEmpty()
  @Type(() => BanUserItemDto)
  banList: BanUserItemDto[];
}

export class BanUserItemDto {
  @ApiProperty()
  @IsUUID()
  @IsNotEmpty()
  userId: UUID;

  @ApiProperty()
  @IsBoolean()
  @IsNotEmpty()
  isBanned: boolean;
}

export class CreateUserDto extends UserRegisterDto {
  @ApiProperty({ default: '' })
  @IsString()
  @IsOptional()
  typeId?: string;
  @ApiProperty({ default: false })
  @IsBoolean()
  @IsOptional()
  isActive?: boolean;
  @ApiProperty({ default: false })
  @IsBoolean()
  @IsOptional()
  isVerified?: boolean;
  @ApiProperty({ default: false })
  @IsBoolean()
  @IsOptional()
  isBanned?: boolean;
  @ApiProperty({ default: 0 })
  @IsNumber()
  @IsOptional()
  credits?: number;
  @ApiProperty({ default: '' })
  @IsString()
  @IsOptional()
  bio?: string;
}
