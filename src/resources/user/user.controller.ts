import { Body, Controller, Get, Param, Put, UseGuards } from '@nestjs/common';
import { UserService } from './user.service';
import { ApiBearerAuth, ApiTags } from '@nestjs/swagger';
import { UserDataType } from 'src/libs/prisma-types';
import {
  getInfomationDecorator,
  getUserInfomationDecorator,
  updateInfomationDecorator,
  updateUserInfomationDecorator,
} from 'src/resources/user/user.decorators';
import {
  IDecodedAccecssTokenType,
  IResponseType,
} from 'src/interfaces/interfaces.global';
import { DecodedAccessToken } from 'src/decorators/decodedAccessToken.decorator';
import { AuthGuard } from '@nestjs/passport';
import { RoleGuard } from 'src/guards/role.guard';
import {
  UpdateProfileDto,
  UpdateUserDto,
} from 'src/resources/user/dto/user.dto';

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

  @Get('/:userId')
  @getUserInfomationDecorator()
  async getUserInfomation(
    @Param('userId') userId: string,
  ): Promise<IResponseType<UserDataType>> {
    return this.userService.getUserInfomation(userId);
  }

  @Put('/me')
  @updateInfomationDecorator()
  async updateInfomation(
    @DecodedAccessToken() decodedAccessToken: IDecodedAccecssTokenType,
    @Body() updateProfileDto: UpdateProfileDto,
  ): Promise<IResponseType<UserDataType>> {
    return this.userService.updateInfomation(
      decodedAccessToken,
      updateProfileDto,
    );
  }

  @Put('/:userId')
  @updateUserInfomationDecorator()
  async updateUserInfomation(
    @Param('userId') userId: string,
    @Body() updateUserDto: UpdateUserDto,
  ): Promise<IResponseType<UserDataType>> {
    return this.userService.updateUserInfomation(userId, updateUserDto);
  }
}
