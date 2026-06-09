import { IsObject, IsOptional, IsString } from 'class-validator';

class PushKeysDto {
  @IsString()
  p256dh: string;

  @IsString()
  auth: string;
}

export class SubscribePushDto {
  @IsString()
  endpoint: string;

  @IsObject()
  keys: PushKeysDto;

  @IsString()
  @IsOptional()
  userAgent?: string;
}

export class UnsubscribePushDto {
  @IsString()
  endpoint: string;
}
