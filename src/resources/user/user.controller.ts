import {
  Body,
  Controller,
  Get,
  MaxFileSizeValidator,
  Param,
  ParseFilePipe,
  Post,
  Put,
  UploadedFile,
  UseGuards,
} from '@nestjs/common';
import { UserService } from './user.service';
import { ApiBearerAuth, ApiTags } from '@nestjs/swagger';
import { UserDataType } from 'src/libs/prisma-types';
import {
  banUserDecorator,
  getInfomationDecorator,
  getUserInfomationDecorator,
  updateInfomationDecorator,
  updateUserAvatarDecorator,
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
  BanUserDto,
  UpdateProfileDto,
  UpdateUserDto,
} from 'src/resources/user/dto/user.dto';
import { FileIsImageValidationPipe } from 'src/pipes/ImageTypeValidator.pipe';

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

  @Post('/ban/:userId')
  @banUserDecorator()
  async banUser(
    @Param('userId') userId: string,
    @Body() banUserData: BanUserDto,
  ): Promise<IResponseType> {
    return this.userService.banUser(userId, banUserData);
  }

  @Post('/avatar/:userId')
  @updateUserAvatarDecorator()
  async updateUserAvatar(
    @Param('userId') userId: string,
    @UploadedFile(
      FileIsImageValidationPipe,
      new ParseFilePipe({
        validators: [
          new MaxFileSizeValidator({
            maxSize: 1024 * 1024 * 5,
            message: 'File size is too large, max 5MB',
          }),
        ],
      }),
    )
    file: Express.Multer.File,
  ): Promise<IResponseType<UserDataType>> {
    return this.userService.updateUserAvatar(userId, file);
  }

  @Put('/me')
  @updateInfomationDecorator()
  async updateInfomation(
    @DecodedAccessToken() decodedAccessToken: IDecodedAccecssTokenType,
    @Body() updateProfileDto: UpdateProfileDto,
  ): Promise<IResponseType<UserDataType>> {
    const userId = decodedAccessToken.userId;
    // return this.userService.updateInfomation(
    //   decodedAccessToken,
    //   updateProfileDto,
    // );
    return this.userService.updateUserInfomation(userId, updateProfileDto);
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
