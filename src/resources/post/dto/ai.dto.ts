import { ApiProperty } from '@nestjs/swagger';
import { IsString, IsNotEmpty } from 'class-validator';

export class GeneratePostDto {
  @ApiProperty({
    description: 'Prompt to generate a blog post',
    example: 'Write a blog post about AI technology',
  })
  @IsString()
  @IsNotEmpty()
  prompt: string;
}
