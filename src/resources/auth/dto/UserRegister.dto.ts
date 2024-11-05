import { ApiProperty } from '@nestjs/swagger';
import { IsNotEmpty, IsNumber, IsString } from 'class-validator';

export class UserRegisterDto {
  @ApiProperty({ default: '' })
  @IsString()
  @IsNotEmpty()
  username: string;
  @ApiProperty({ default: '' })
  @IsString()
  @IsNotEmpty()
  email: string;
  @ApiProperty({ default: '' })
  @IsString()
  @IsNotEmpty()
  displayName: string;
  @ApiProperty({ default: '' })
  @IsString()
  @IsNotEmpty()
  fullName: string;
  @ApiProperty({ default: '' })
  @IsString()
  @IsNotEmpty()
  phoneNumber: string;
  @ApiProperty({ default: 0 })
  @IsNumber()
  @IsNotEmpty()
  age: number;
  @ApiProperty({ default: '' })
  @IsString()
  @IsNotEmpty()
  password: string;
}
