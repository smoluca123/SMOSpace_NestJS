import {
  Body,
  Controller,
  Get,
  MaxFileSizeValidator,
  Param,
  ParseFilePipe,
  Post,
  Put,
  Query,
  UploadedFile,
} from '@nestjs/common';
import { UserService } from './user.service';
import { ApiBearerAuth, ApiTags } from '@nestjs/swagger';
import {
  banUserDecorator,
  followUserDecorator,
  getAllUsersDecorator,
  getInfomationDecorator,
  getUserInfomationDecorator,
  updateInfomationDecorator,
  updateUserAvatarDecorator,
  updateUserInfomationDecorator,
} from 'src/resources/user/user.decorators';
import { IDecodedAccecssTokenType } from 'src/interfaces/interfaces.global';
import { DecodedAccessToken } from 'src/decorators/decodedAccessToken.decorator';
import {
  BanUserDto,
  UpdateProfileDto,
  UpdateUserDto,
  UserActiveByCodeDto,
  UserCreditsUpdateDto,
} from 'src/resources/user/dto/user.dto';
import { FileIsImageValidationPipe } from 'src/pipes/ImageTypeValidator.pipe';

@ApiTags('User Management')
@ApiBearerAuth()
@Controller('user')
export class UserController {
  constructor(private readonly userService: UserService) {}

  @Get('/')
  @getAllUsersDecorator()
  async getAllUsers(
    @Query('page') page: number = 1,
    @Query('limit') limit: number = 10,
    @Query('keywords') keywords: string,
  ) {
    return this.userService.getAllUsers({
      keywords,
      limit: +limit,
      page: +page,
    });
  }

  @Get('/me')
  @getInfomationDecorator()
  async getInfomation(
    @DecodedAccessToken() decodedAccessToken: IDecodedAccecssTokenType,
  ) {
    return this.userService.getInfomation(decodedAccessToken);
  }

  @Get('/:userId')
  @getUserInfomationDecorator()
  async getUserInfomation(
    @Param('userId') userId: string,
    @Query('followerId') followerId: string,
  ) {
    console.log(followerId);
    return this.userService.getUserInfomation({ userId, followerId });
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
  ) {
    return this.userService.updateUserAvatar(userId, file);
  }

  @Post('/credits/add/:userId')
  async addUserCredits(
    @Param('userId') userId: string,
    @Body() data: UserCreditsUpdateDto,
  ) {
    const { amount } = data;
    return this.userService.addUserCredits(userId, {
      credits: amount,
    });
  }

  @Post('/active/send-verification-email/:userId')
  async sendVerificationEmail(@Param('userId') userId: string) {
    return this.userService.sendVerificationEmail(userId);
  }

  @Post('/active/:userId')
  userActiveByCode(
    @Param('userId') userId: string,
    @Body() verificationData: UserActiveByCodeDto,
  ) {
    return this.userService.userActiveByCode(userId, verificationData);
  }

  @Post('/follow/:userId')
  @followUserDecorator()
  followUser(
    @Param('userId') userId: string,
    @DecodedAccessToken() decodedAccessToken: IDecodedAccecssTokenType,
  ) {
    return this.userService.followUser({
      userId,
      followerUserId: decodedAccessToken.userId,
    });
  }

  @Put('/ban/:userId')
  @banUserDecorator()
  async banUser(
    @Param('userId') userId: string,
    @Body() banUserData: BanUserDto,
  ) {
    const result = await this.userService.banUser(userId, banUserData);

    return result;
  }
  @Put('/credits/update/:userId')
  async updateUserCredits(
    @Param('userId') userId: string,
    @Body() data: UserCreditsUpdateDto,
  ) {
    const { amount } = data;
    return this.userService.updateUserCredits(userId, {
      credits: amount,
    });
  }

  @Put('/me')
  @updateInfomationDecorator()
  async updateInfomation(
    @DecodedAccessToken() decodedAccessToken: IDecodedAccecssTokenType,
    @Body() updateProfileDto: UpdateProfileDto,
  ) {
    const userId = decodedAccessToken.userId;
    return this.userService.updateUserInfomation(userId, updateProfileDto);
  }

  @Put('/:userId')
  @updateUserInfomationDecorator()
  async updateUserInfomation(
    @Param('userId') userId: string,
    @Body() updateUserDto: UpdateUserDto,
  ) {
    return this.userService.updateUserInfomation(userId, updateUserDto);
  }
}
