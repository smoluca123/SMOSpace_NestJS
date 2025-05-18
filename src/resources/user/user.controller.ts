import {
  BadRequestException,
  Body,
  Controller,
  Delete,
  Get,
  MaxFileSizeValidator,
  Param,
  ParseFilePipe,
  Post,
  Put,
  Query,
  UploadedFile,
  UseGuards,
} from '@nestjs/common';
import { UserService } from './user.service';
import { ApiBearerAuth, ApiOperation, ApiTags } from '@nestjs/swagger';
import {
  banUserDecorator,
  changeFriendshipStatusDecorator,
  followUserDecorator,
  getFriendListDecorator,
  getAllUsersDecorator,
  getFollowersByIdDecorator,
  getFollowersDecorator,
  getFollowingsByIdDecorator,
  getFollowingsDecorator,
  getInformationDecorator,
  getPendingFriendsRequestDecorator,
  getUserInformationDecorator,
  toggleBlockFriendDecorator,
  toggleFriendshipRequestDecorator,
  updateInformationDecorator,
  updateUserAvatarDecorator,
  updateUserCoverImageDecorator,
  updateUserInformationDecorator,
  removeFriendDecorator,
} from 'src/resources/user/user.decorators';
import { IDecodedAccecssTokenType } from 'src/interfaces/interfaces.global';
import { DecodedAccessToken } from 'src/decorators/decodedAccessToken.decorator';
import {
  BanUserDto,
  ChangeFriendshipStatusDto,
  UpdateProfileDto,
  UpdateUserDto,
  UserActiveByCodeDto,
  UserCreditsUpdateDto,
  UserResetPasswordDto,
} from 'src/resources/user/dto/user.dto';
import { FileIsImageValidationPipe } from 'src/pipes/ImageTypeValidator.pipe';
import { normalizePaginationParams } from 'src/utils/utils';
import { AuthGuard } from '@nestjs/passport';
import { RoleGuard } from 'src/guards/role.guard';
import { FriendStatus } from '@prisma/client';

@ApiTags('User Management')
@ApiBearerAuth()
@UseGuards(AuthGuard('jwt'), RoleGuard)
@Controller('user')
export class UserController {
  constructor(private readonly userService: UserService) {}

  @Get('/friends')
  @getFriendListDecorator()
  async getFriendList(
    @DecodedAccessToken() decodedAccessToken: IDecodedAccecssTokenType,
    @Query('page') _page?: string,
    @Query('limit') _limit?: string,
  ) {
    const { userId } = decodedAccessToken;
    const { limit, page } = normalizePaginationParams({
      limit: +_limit,
      page: +_page,
    });
    return this.userService.getFriendList({
      userId,
      limit,
      page,
    });
  }

  @Get('/friends/pending')
  @getPendingFriendsRequestDecorator()
  async getPendingFriendsRequest(
    @DecodedAccessToken() decodedAccessToken: IDecodedAccecssTokenType,
    @Query('page') _page?: string,
    @Query('limit') _limit?: string,
  ) {
    const { userId } = decodedAccessToken;
    const { limit, page } = normalizePaginationParams({
      limit: +_limit,
      page: +_page,
    });
    return this.userService.getPendingFriendsRequest({
      userId,
      limit,
      page,
    });
  }

  @Get('/followers')
  @getFollowersDecorator()
  async getFollowers(
    @DecodedAccessToken() decodedAccessToken: IDecodedAccecssTokenType,
    @Query('page') _page: string,
    @Query('limit') _limit: string,
  ) {
    const { userId } = decodedAccessToken;
    const { limit, page } = normalizePaginationParams({
      limit: +_limit,
      page: +_page,
    });
    return this.userService.getFollowers({ userId, limit, page });
  }

  @Get('/followers/:userId')
  @getFollowersByIdDecorator()
  async getFollowersById(
    @Param('userId') userId: string,
    @Query('page') _page: string,
    @Query('limit') _limit: string,
    @Query('followerId') followerId: string,
  ) {
    const { limit, page } = normalizePaginationParams({
      limit: +_limit,
      page: +_page,
    });
    return this.userService.getFollowersById({
      userId,
      limit,
      page,
      followerId,
    });
  }

  @Get('/followings')
  @getFollowingsDecorator()
  async getFollowings(
    @DecodedAccessToken() decodedAccessToken: IDecodedAccecssTokenType,
    @Query('page') _page: string,
    @Query('limit') _limit: string,
  ) {
    const { userId } = decodedAccessToken;
    const { limit, page } = normalizePaginationParams({
      limit: +_limit,
      page: +_page,
    });
    return this.userService.getFollowings({ userId, limit, page });
  }

  @Get('/followings/:userId')
  @getFollowingsByIdDecorator()
  async getFollowingsById(
    @Param('userId') userId: string,
    @Query('page') _page: string,
    @Query('limit') _limit: string,
  ) {
    const { limit, page } = normalizePaginationParams({
      limit: +_limit,
      page: +_page,
    });
    return this.userService.getFollowings({ userId, limit, page });
  }

  @Get('/')
  @getAllUsersDecorator()
  async getAllUsers(
    @Query('page') _page: string,
    @Query('limit') _limit: string,
    @Query('keywords') keywords: string,
    @Query('currentUserId') currentUserId?: string,
  ) {
    const { limit, page } = normalizePaginationParams({
      limit: +_limit,
      page: +_page,
    });
    return this.userService.getAllUsers({
      keywords,
      limit,
      page,
      currentUserId,
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
    @Query('currentUserId') currentUserId?: string,
  ) {
    return this.userService.getUserInformation({ userId, currentUserId });
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

  @Post('/cover-image/:userId')
  @updateUserCoverImageDecorator()
  async updateUserCoverImage(
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
    return this.userService.updateUserCoverImage({ userId, file });
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

  @Post('/forgot-password/send-verification-email/:userEmail')
  @ApiOperation({
    summary: 'Send forgot password email to user',
    description: 'Send a forgot password email to a specific user',
  })
  async sendForgotPasswordEmail(@Param('userEmail') userEmail: string) {
    return this.userService.sendForgotPasswordEmail(userEmail);
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

  @Post('/forgot-password/:userEmail')
  @ApiOperation({
    summary: 'Reset password by verification code',
    description: 'Reset a user password by verifying the provided code',
  })
  resetPassword(
    @Param('userEmail') userEmail: string,
    @Body() resetPasswordData: UserResetPasswordDto,
  ) {
    return this.userService.resetPassword(userEmail, resetPasswordData);
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

  @Post('/friend/:userId')
  @toggleFriendshipRequestDecorator()
  toggleFriendshipRequest(
    @Param('userId') userId: string,
    @DecodedAccessToken() decodedAccessToken: IDecodedAccecssTokenType,
  ) {
    return this.userService.toggleFriendshipRequest({
      userId,
      currentUserId: decodedAccessToken.userId,
    });
  }

  @Post('/friend/status/:userId')
  @changeFriendshipStatusDecorator()
  changeFriendshipStatus(
    @Param('userId') userId: string,
    @DecodedAccessToken() decodedAccessToken: IDecodedAccecssTokenType,
    @Body() data: ChangeFriendshipStatusDto,
  ) {
    switch (data.status) {
      case FriendStatus.ACCEPTED:
        return this.userService.acceptFriendshipRequest({
          userId,
          currentUserId: decodedAccessToken.userId,
        });
      case FriendStatus.REJECTED:
        return this.userService.rejectFriendshipRequest({
          userId,
          currentUserId: decodedAccessToken.userId,
        });
      default:
        throw new BadRequestException('Invalid friendship status');
    }
  }

  @Post('/friend/block/:userId')
  @toggleBlockFriendDecorator()
  toggleBlockFriend(
    @Param('userId') userId: string,
    @DecodedAccessToken() decodedAccessToken: IDecodedAccecssTokenType,
  ) {
    return this.userService.toggleBlockFriend({
      userId,
      currentUserId: decodedAccessToken.userId,
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

  @Delete('/friend/:userId')
  @removeFriendDecorator()
  removeFriend(
    @Param('userId') userId: string,
    @DecodedAccessToken() decodedAccessToken: IDecodedAccecssTokenType,
  ) {
    return this.userService.removeFriend({
      userId,
      currentUserId: decodedAccessToken.userId,
    });
  }
}
