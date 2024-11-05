import { Body, Controller, Get, Post, Res, UseGuards } from '@nestjs/common';
import { AuthService } from './auth.service';
import { ApiBearerAuth, ApiTags } from '@nestjs/swagger';
import {
  IDecodedAccecssTokenType,
  IResponseType,
} from 'src/interfaces/interface.global';
import { UserLoginDto } from 'src/resources/auth/dto/UserLogin.dto';
import { UserRegisterDto } from 'src/resources/auth/dto/UserRegister.dto';
import {
  decoratorsAuthLogin,
  decoratorsAuthLogout,
  decoratorsAuthRegister,
  decoratorsValidateSession,
} from 'src/resources/auth/auth.decorators';
import { DecodedAccessToken } from 'src/decorators/decodedAccessToken.decorator';
import { Response } from 'express';
import { Cookies } from 'src/decorators/cookies.decorator';
import { UserAgent } from 'src/decorators/utils.decorator';
import { IpAddress } from 'src/decorators/ip.decorator';
import { CookieName } from 'src/global/enums.global';
import { AuthGuard } from '@nestjs/passport';
// import { AuthGuard } from '@nestjs/passport';

@ApiTags('User Management')
@ApiBearerAuth()
@UseGuards(AuthGuard('jwt'))
@Controller('auth')
export class AuthController {
  constructor(private readonly authService: AuthService) {}

  @Post('/login')
  @decoratorsAuthLogin()
  async authLogin(
    @Body() credentials: UserLoginDto,
    @Res({ passthrough: true }) response: Response,
    @UserAgent() userAgent: string,
    @IpAddress() ipAddess: string,
  ): Promise<IResponseType> {
    const result = await this.authService.authLogin(
      credentials,
      response,
      userAgent,
      ipAddess,
    );

    return result;
  }

  @Post('/register')
  @decoratorsAuthRegister()
  authRegister(
    @Body() credentials: UserRegisterDto,
    @Res({ passthrough: true }) response: Response,
    @UserAgent() userAgent: string,
    @IpAddress() ipAddess: string,
  ): Promise<IResponseType> {
    return this.authService.authRegister(
      credentials,
      response,
      userAgent,
      ipAddess,
    );
  }

  @Get('/validate-session')
  @decoratorsValidateSession()
  authValidateSession(
    @Cookies(CookieName.SESSION_ID) sessionId: string,
    @DecodedAccessToken() decodedAccessToken: IDecodedAccecssTokenType,
  ): Promise<IResponseType> {
    return this.authService.authValidateSession(sessionId, decodedAccessToken);
  }

  @Get('/logout')
  @decoratorsAuthLogout()
  authLogout(
    @Cookies(CookieName.SESSION_ID) sessionId: string,
    @DecodedAccessToken() decodedAccessToken: IDecodedAccecssTokenType,
    @Res({ passthrough: true }) response: Response,
  ): Promise<IResponseType> {
    return this.authService.authLogout(sessionId, decodedAccessToken, response);
  }

  // @Get('lyric/:trackId')
  // getLyric(@Param('trackId') trackId: string): Promise<IResponseType> {
  //   return this.authService.getLyric(trackId);
  // }
}
