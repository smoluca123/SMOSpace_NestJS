import { Controller, Get, Param, UseGuards } from '@nestjs/common';
import { UserService } from './user.service';
import { ApiBearerAuth, ApiTags } from '@nestjs/swagger';
import { UserDataType } from 'src/libs/prisma-types';
import {
  getInfomationDecorator,
  getUserInfomationDecorator,
} from 'src/resources/user/user.decorators';
import {
  IDecodedAccecssTokenType,
  IResponseType,
} from 'src/interfaces/interfaces.global';
import { DecodedAccessToken } from 'src/decorators/decodedAccessToken.decorator';
import { AuthGuard } from '@nestjs/passport';
import { RoleGuard } from 'src/guards/role.guard';

@ApiTags('User Management')
@ApiBearerAuth()
@UseGuards(AuthGuard('jwt'), RoleGuard)
@Controller('user')
export class UserController {
  constructor(private readonly userService: UserService) {}

  @Get('/me')
  @getInfomationDecorator()
  async getInfomation(
    @DecodedAccessToken() decodedAccessToken: IDecodedAccecssTokenType,
  ): Promise<IResponseType<UserDataType>> {
    return this.userService.getInfomation(decodedAccessToken);
  }

  @Get('/user/:userId')
  @getUserInfomationDecorator()
  async getUserInfomation(
    @Param('userId') userId: string,
  ): Promise<IResponseType<UserDataType>> {
    return this.userService.getUserInfomation(userId);
  }
}
