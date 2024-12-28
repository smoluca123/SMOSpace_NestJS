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
import { ApiBearerAuth, ApiOperation, ApiTags } from '@nestjs/swagger';
import {
  banUserDecorator,
  followUserDecorator,
  getAllUsersDecorator,
  getInformationDecorator,
  getUserInformationDecorator,
  updateInformationDecorator,
  updateUserAvatarDecorator,
  updateUserInformationDecorator,
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
import { normalizePaginationParams } from 'src/utils/utils';

@ApiTags('User Management')
@ApiBearerAuth()
@Controller('user')
export class UserController {
  constructor(private readonly userService: UserService) {}

  @Get('/')
  @getAllUsersDecorator()
  async getAllUsers(
    @Query('page') _page: number,
    @Query('limit') _limit: number,
    @Query('keywords') keywords: string,
    @Query('followerId') followerId: string,
  ) {
    const { limit, page } = normalizePaginationParams({
      limit: _limit,
      page: _page,
    });
    return this.userService.getAllUsers({
      keywords,
      limit,
      page: +page,
      followerId,
    });
  }

  @Get('/me')
  @getInformationDecorator()
  async getInformation(
    @DecodedAccessToken() decodedAccessToken: IDecodedAccecssTokenType,
  ) {
    return this.userService.getInformation(decodedAccessToken);
  }

  @Get('/:userId')
  @getUserInformationDecorator()
  async getUserInformation(
    @Param('userId') userId: string,
    @Query('followerId') followerId: string,
  ) {
    return this.userService.getUserInformation({ userId, followerId });
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
  @ApiOperation({
    summary: 'Add credits to a user',
    description: 'Add credits to a specific user',
  })
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
  @ApiOperation({
    summary: 'Send verification email to user',
    description: 'Send a verification email to a specific user',
  })
  async sendVerificationEmail(@Param('userId') userId: string) {
    return this.userService.sendVerificationEmail(userId);
  }

  @Post('/active/:userId')
  @ApiOperation({
    summary: 'Activate user account by verification code',
    description: 'Activate a user account by verifying the provided code',
  })
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
  @ApiOperation({
    summary: 'Update user credits',
    description: 'Update the credits of a specific user',
  })
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
  @updateInformationDecorator()
  async updateInfomation(
    @DecodedAccessToken() decodedAccessToken: IDecodedAccecssTokenType,
    @Body() updateProfileDto: UpdateProfileDto,
  ) {
    const userId = decodedAccessToken.userId;
    return this.userService.updateUserInformation(userId, updateProfileDto);
  }

  @Put('/:userId')
  @updateUserInformationDecorator()
  async updateUserInfomation(
    @Param('userId') userId: string,
    @Body() updateUserDto: UpdateUserDto,
  ) {
    return this.userService.updateUserInformation(userId, updateUserDto);
  }
}
