import {
  Body,
  Controller,
  Get,
  Headers,
  Post,
  Res,
  UseGuards,
} from '@nestjs/common';
import { AuthService } from './auth.service';
import { ApiBearerAuth, ApiTags } from '@nestjs/swagger';
import { IDecodedAccecssTokenType } from 'src/interfaces/interfaces.global';
import { UserLoginDto } from 'src/resources/auth/dto/UserLogin.dto';
import { UserRegisterDto } from 'src/resources/auth/dto/UserRegister.dto';
import {
  decoratorsAuthLogin,
  decoratorsAuthLogout,
  decoratorsAuthRegister,
  decoratorsRenewSession,
  decoratorsValidateSession,
} from 'src/resources/auth/auth.decorators';
import { DecodedAccessToken } from 'src/decorators/decodedAccessToken.decorator';
import { UserAgent } from 'src/decorators/utils.decorator';
import { IpAddress } from 'src/decorators/ip.decorator';
import { Response } from 'express';
import { Throttle } from '@nestjs/throttler';
import { AuthGuard } from '@nestjs/passport';
// import { AuthGuard } from '@nestjs/passport';

@ApiTags('User Management')
@ApiBearerAuth()
@UseGuards(AuthGuard('jwt'))
@Throttle({
  default: {
    ttl: 60 * 60 * 1000, // 1 hour
    limit: 50, // 5 requests per hour
  },
})
@Controller('auth')
export class AuthController {
  constructor(private readonly authService: AuthService) {}

  @Post('/login')
  @decoratorsAuthLogin()
  async authLogin(
    @Body() credentials: UserLoginDto,
    @UserAgent() userAgent: string,
    @IpAddress() ipAddress: string,
    @Res({ passthrough: true }) response: Response,
  ) {
    return await this.authService.authLogin({
      credentials,
      userAgent,
      ipAddress,
      response,
    });
  }

  @Post('/register')
  @decoratorsAuthRegister()
  authRegister(
    @Body() credentials: UserRegisterDto,
    @UserAgent() userAgent: string,
    @IpAddress() ipAddess: string,
  ) {
    return this.authService.authRegister(credentials, userAgent, ipAddess);
  }

  @Get('/validate-session')
  @decoratorsValidateSession()
  authValidateSession(
    @DecodedAccessToken() decodedAccessToken: IDecodedAccecssTokenType,
  ) {
    return this.authService.authValidateSession(decodedAccessToken);
  }

  @Get('/logout')
  @decoratorsAuthLogout()
  authLogout(
    @DecodedAccessToken() decodedAccessToken: IDecodedAccecssTokenType,
  ) {
    return this.authService.authLogout(decodedAccessToken);
  }

  @Post('/renew-session')
  @decoratorsRenewSession()
  async refreshToken(@Headers('accessToken') accessToken: string) {
    return this.authService.renewSession(accessToken);
  }
}
