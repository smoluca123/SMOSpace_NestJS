import { Body, Controller, Get, Post, UseGuards } from '@nestjs/common';
import { ApiBearerAuth, ApiHeader, ApiTags } from '@nestjs/swagger';
import { DecodedAccessToken } from 'src/decorators/decodedAccessToken.decorator';
import { JwtTokenVerifyGuard } from 'src/guards/jwt-token-verify.guard';
import { IDecodedAccecssTokenType } from 'src/interfaces/interfaces.global';
import {
  SubscribePushDto,
  UnsubscribePushDto,
} from 'src/resources/push/dto/push.dto';
import { PushService } from 'src/resources/push/push.service';

@ApiTags('Push Notifications')
@Controller('push')
export class PushController {
  constructor(private readonly pushService: PushService) {}

  /** Public VAPID key the browser needs to create a push subscription. */
  @Get('public-key')
  getPublicKey() {
    return {
      message: 'Public key fetched',
      data: { publicKey: this.pushService.getPublicKey() },
      statusCode: 200,
      date: new Date(),
    };
  }

  @Post('subscribe')
  @ApiBearerAuth()
  @ApiHeader({
    name: 'accessToken',
    description: 'JWT access token',
    required: true,
  })
  @UseGuards(JwtTokenVerifyGuard)
  async subscribe(
    @DecodedAccessToken() decoded: IDecodedAccecssTokenType,
    @Body() body: SubscribePushDto,
  ) {
    await this.pushService.saveSubscription(
      decoded.userId,
      { endpoint: body.endpoint, keys: body.keys },
      body.userAgent,
    );
    return {
      message: 'Subscribed to push notifications',
      data: null,
      statusCode: 201,
      date: new Date(),
    };
  }

  @Post('unsubscribe')
  @ApiBearerAuth()
  @ApiHeader({
    name: 'accessToken',
    description: 'JWT access token',
    required: true,
  })
  @UseGuards(JwtTokenVerifyGuard)
  async unsubscribe(@Body() body: UnsubscribePushDto) {
    await this.pushService.removeSubscription(body.endpoint);
    return {
      message: 'Unsubscribed from push notifications',
      data: null,
      statusCode: 200,
      date: new Date(),
    };
  }
}
