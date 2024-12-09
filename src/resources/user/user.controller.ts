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
} from '@nestjs/common';
import { UserService } from './user.service';
import { ApiBearerAuth, ApiResponse, ApiTags } from '@nestjs/swagger';
import {
  banUserDecorator,
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
import {
  SendVerificationEmailResponseDto,
  UpdateAddCreditsUserResponseDto,
  UserInfomationResponseDto,
} from 'src/resources/user/dto/Responses.dto';

@ApiTags('User Management')
@ApiBearerAuth()
@Controller('user')
export class UserController {
  constructor(private readonly userService: UserService) {}

  @Get('/me')
  @getInfomationDecorator()
  async getInfomation(
    @DecodedAccessToken() decodedAccessToken: IDecodedAccecssTokenType,
  ) {
    return this.userService.getInfomation(decodedAccessToken);
  }

  @Get('/:userId')
  @getUserInfomationDecorator()
  async getUserInfomation(@Param('userId') userId: string) {
    return this.userService.getUserInfomation(userId);
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

  @Put('/credits/update/:userId')
  @ApiResponse({
    status: 200,
    type: UpdateAddCreditsUserResponseDto,
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

  @Post('/credits/add/:userId')
  @ApiResponse({
    status: 200,
    type: UpdateAddCreditsUserResponseDto,
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

  @Post('/active/send-verification-email/:userId')
  @ApiResponse({
    status: 200,
    type: SendVerificationEmailResponseDto,
  })
  async sendVerificationEmail(@Param('userId') userId: string) {
    return this.userService.sendVerificationEmail(userId);
  }

  @Post('/active/:userId')
  @ApiResponse({
    status: 200,
    type: UserInfomationResponseDto,
  })
  async userActiveByCode(
    @Param('userId') userId: string,
    @Body() verificationData: UserActiveByCodeDto,
  ) {
    return this.userService.userActiveByCode(userId, verificationData);
  }
}
