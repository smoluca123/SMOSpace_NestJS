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
  display_name: string;
  @ApiProperty({ default: '' })
  @IsString()
  @IsNotEmpty()
  full_name: string;
  @ApiProperty({ default: '' })
  @IsString()
  @IsNotEmpty()
  phone_number: string;
  @ApiProperty({ default: 0 })
  @IsNumber()
  @IsNotEmpty()
  age: number;
  @ApiProperty({ default: '' })
  @IsString()
  @IsNotEmpty()
  password: string;
}
