import { IsString, IsEnum, IsOptional, IsArray } from 'class-validator';
import { MessageType, ReactionType } from '@prisma/client';

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

  @IsOptional()
  isForwarded?: boolean;
}

export class SharePostToChatDto {
  /** Existing room ids to send the shared post into. */
  @IsArray()
  @IsString({ each: true })
  @IsOptional()
  roomIds?: string[];

  /** User ids to share with directly (a direct room is created/reused). */
  @IsArray()
  @IsString({ each: true })
  @IsOptional()
  userIds?: string[];
}

export class ForwardMessageDto {
  @IsArray()
  @IsString({ each: true })
  roomIds: string[];
}

export class CreateGroupDto {
  @IsString()
  name: string;

  @IsArray()
  @IsString({ each: true })
  participantIds: string[];
}

export class ReactToMessageDto {
  @IsEnum(ReactionType)
  type: ReactionType;
}
