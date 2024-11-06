import { Body, Controller, Get, Post, UseGuards } from '@nestjs/common';
import { AuthService } from './auth.service';
import { ApiBearerAuth, ApiTags } from '@nestjs/swagger';
import {
  IDecodedAccecssTokenType,
  IResponseType,
} from 'src/interfaces/interfaces.global';
import { UserLoginDto } from 'src/resources/auth/dto/UserLogin.dto';
import { UserRegisterDto } from 'src/resources/auth/dto/UserRegister.dto';
import {
  decoratorsAuthLogin,
  decoratorsAuthLogout,
  decoratorsAuthRegister,
  decoratorsValidateSession,
} from 'src/resources/auth/auth.decorators';
import { DecodedAccessToken } from 'src/decorators/decodedAccessToken.decorator';
import { UserAgent } from 'src/decorators/utils.decorator';
import { IpAddress } from 'src/decorators/ip.decorator';
import { UserDataType } from 'src/libs/prisma-types';
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
    @UserAgent() userAgent: string,
    @IpAddress() ipAddess: string,
  ): Promise<IResponseType<UserDataType>> {
    return await this.authService.authLogin(credentials, userAgent, ipAddess);
  }

  @Post('/register')
  @decoratorsAuthRegister()
  authRegister(
    @Body() credentials: UserRegisterDto,
    @UserAgent() userAgent: string,
    @IpAddress() ipAddess: string,
  ): Promise<IResponseType<UserDataType>> {
    return this.authService.authRegister(credentials, userAgent, ipAddess);
  }

  @Get('/validate-session')
  @decoratorsValidateSession()
  authValidateSession(
    @DecodedAccessToken() decodedAccessToken: IDecodedAccecssTokenType,
  ): Promise<IResponseType> {
    return this.authService.authValidateSession(decodedAccessToken);
  }

  @Get('/logout')
  @decoratorsAuthLogout()
  authLogout(
    @DecodedAccessToken() decodedAccessToken: IDecodedAccecssTokenType,
  ): Promise<IResponseType> {
    return this.authService.authLogout(decodedAccessToken);
  }

  // @Get('lyric/:trackId')
  // getLyric(@Param('trackId') trackId: string): Promise<IResponseType> {
  //   return this.authService.getLyric(trackId);
  // }
}
