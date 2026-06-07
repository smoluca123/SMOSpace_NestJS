import { IsString, IsEnum, IsOptional, IsArray } from 'class-validator';
import { MessageType } from '@prisma/client';

export class CreateFirstMessageDto {
  @IsString()
  content: string;

  @IsEnum(MessageType)
  @IsOptional()
  type?: MessageType = MessageType.TEXT;

  @IsString()
  @IsOptional()
  replyToId?: string;
}

export class CreateMessageDto {
  @IsString()
  roomId: string;

  @IsString()
  content: string;

  @IsEnum(MessageType)
  @IsOptional()
  type?: MessageType = MessageType.TEXT;

  @IsString()
  @IsOptional()
  replyToId?: string;
}

export class CreateGroupDto {
  @IsString()
  name: string;

  @IsArray()
  @IsString({ each: true })
  participantIds: string[];
}
