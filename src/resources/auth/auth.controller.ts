import { Body, Controller, Get, Post, Res, UseGuards } from '@nestjs/common';
import { AuthService } from './auth.service';
import { ApiBearerAuth, ApiTags } from '@nestjs/swagger';
import { AuthGuard } from '@nestjs/passport';
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
} from 'src/resources/auth/auth.decorators';
import { DecodedAccessToken } from 'src/decorators/decodedAccessToken.decorator';
import { Response } from 'express';
import { Cookies } from 'src/decorators/cookies.decorator';
import { UserAgent } from 'src/decorators/utils.decorator';
import { IpAddress } from 'src/decorators/ip.decorator';

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

  @Get('/logout')
  @decoratorsAuthLogout()
  getInfomation(
    @Cookies('accessToken') accessToken: string,
    @DecodedAccessToken() decodedAccessToken: IDecodedAccecssTokenType,
    @UserAgent() userAgent: string,
  ): Promise<IResponseType> {
    return this.authService.authLogout(
      decodedAccessToken,
      accessToken,
      userAgent,
    );
  }
}
