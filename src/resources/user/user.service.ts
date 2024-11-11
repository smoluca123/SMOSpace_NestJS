import {
  BadRequestException,
  ForbiddenException,
  Injectable,
  NotFoundException,
} from '@nestjs/common';
import {
  generateSecureVerificationCode,
  handleDefaultError,
} from 'src/global/functions.global';
import {
  IDecodedAccecssTokenType,
  IResponseType,
} from 'src/interfaces/interfaces.global';
import { userDataSelect, UserDataType } from 'src/libs/prisma-types';
import { PrismaService } from 'src/prisma/prisma.service';
import {
  BanUserDto,
  RefreshTokenResponseDto,
  UpdateProfileDto,
  UserActiveByCodeDto,
} from 'src/resources/user/dto/user.dto';
import * as bcrypt from 'bcryptjs';
import { ConfigService } from '@nestjs/config';
import { SupabaseService } from 'src/supabase/supabase.service';
import { EmailService } from 'src/resources/email/email.service';
import { addMinutes, fromUnixTime, isPast } from 'date-fns';
import { JwtServiceCustom } from 'src/jwt/jwt.service';
import { v4 } from 'uuid';
import { JwtService } from '@nestjs/jwt';

@Injectable()
export class UserService {
  constructor(
    private readonly prisma: PrismaService,
    private readonly config: ConfigService,
    private readonly supabase: SupabaseService,
    private readonly emailService: EmailService,
    private readonly jwt: JwtService,
    private readonly customJwt: JwtServiceCustom,
  ) {}
  async getInfomation(
    decodedAccessToken: IDecodedAccecssTokenType,
  ): Promise<IResponseType<UserDataType>> {
    try {
      const user = await this.prisma.user.findUnique({
        where: {
          id: decodedAccessToken.userId,
        },
        select: userDataSelect,
      });

      if (!user) throw new NotFoundException('User not found');

      return {
        message: 'Get user information successfully',
        data: user,
        statusCode: 200,
        date: new Date(),
      };
    } catch (error) {
      handleDefaultError(error);
    }
  }

  async getUserInfomation(
    userId: string,
  ): Promise<IResponseType<UserDataType>> {
    try {
      if (!userId) throw new BadRequestException('User ID is required');

      const user = await this.prisma.user.findFirst({
        where: {
          // username: userId,
          OR: [{ username: userId }, { id: userId }],
          // OR: [{  }],
        },
        select: userDataSelect,
      });

      if (!user) throw new NotFoundException('User not found');

      return {
        message: 'Get user information successfully',
        data: user,
        statusCode: 200,
        date: new Date(),
      };
    } catch (error) {
      handleDefaultError(error);
    }
  }

  async banUser(userId: string, data: BanUserDto): Promise<IResponseType> {
    try {
      if (!userId) throw new BadRequestException('User ID is required');

      await this.prisma.user.update({
        where: { id: userId },
        data: { isBanned: data.isBanned },
      });
      return {
        message: `${data.isBanned ? 'Ban' : 'Unban'} user successfully`,
        data: null,
        statusCode: 204,
        date: new Date(),
      };
    } catch (error) {
      handleDefaultError(error);
    }
  }

  async updateInfomation(
    decodedAccessToken: IDecodedAccecssTokenType,
    data: UpdateProfileDto,
  ) {
    try {
      Object.keys(data).forEach(async (key) => {
        if (!data[key]) {
          data[key] = undefined;
          return;
        }
        if (key === 'password') {
          data[key] = await bcrypt.hash(data[key], 10);
        }
      });
      const user = await this.prisma.user.update({
        where: {
          id: decodedAccessToken.userId,
        },
        data,
        select: userDataSelect,
      });

      if (!user) throw new NotFoundException('User not found');

      return {
        message: 'Update information successfully',
        data: user,
        statusCode: 200,
        date: new Date(),
      };
    } catch (error) {
      handleDefaultError(error);
    }
  }

  async updateUserInfomation(userId: string, data: UpdateProfileDto) {
    try {
      if (!userId) throw new BadRequestException('User ID is required');

      Object.keys(data).forEach(async (key) => {
        if (typeof data[key] !== 'boolean' && !data[key]) {
          data[key] = undefined;
          return;
        }
        if (key === 'password') {
          data[key] = await bcrypt.hash(data[key], 10);
        }
      });
      const user = await this.prisma.user.update({
        where: {
          id: userId,
        },
        data,
        select: userDataSelect,
      });
      if (!user) throw new NotFoundException('User not found');

      return {
        message: 'Update user information successfully',
        data: user,
        statusCode: 200,
        date: new Date(),
      };
    } catch (error) {
      handleDefaultError(error);
    }
  }

  async updateUserAvatar(
    userId: string,
    file: Express.Multer.File,
  ): Promise<IResponseType<UserDataType>> {
    try {
      if (!userId) throw new BadRequestException('User ID is required');

      const checkUser = await this.prisma.user.findUnique({
        where: { id: userId },
      });

      if (!checkUser) throw new NotFoundException('User not found');

      const { url } = await this.supabase.uploadFile(file);

      // console.log(uploadedAvatar);
      const updatedUser = await this.prisma.user.update({
        where: { id: userId },
        data: { avatar: url },
        select: userDataSelect,
      });

      return {
        message: 'Update user avatar successfully',
        data: updatedUser,
        statusCode: 200,
        date: new Date(),
      };
    } catch (error) {
      handleDefaultError(error);
    }
  }

  async updateUserCredits(
    userId: string,
    data: {
      credits: number;
    },
  ): Promise<
    IResponseType<{
      id: string;
      username: string;
      credits: number;
    }>
  > {
    try {
      const updatedUser = await this.prisma.user.update({
        where: { id: userId },
        data,
        select: { id: true, username: true, credits: true },
      });

      if (!updatedUser) throw new NotFoundException('User not found');

      return {
        message: 'Update user credits successfully',
        data: updatedUser,
        statusCode: 200,
        date: new Date(),
      };
    } catch (error) {
      handleDefaultError(error);
    }
  }

  async addUserCredits(
    userId: string,
    data: {
      credits: number;
    },
  ): Promise<
    IResponseType<{
      id: string;
      username: string;
      credits: number;
    }>
  > {
    try {
      const updatedUser = await this.prisma.user.update({
        where: { id: userId },
        data: {
          credits: {
            increment: data.credits,
          },
        },
        select: { id: true, username: true, credits: true },
      });

      if (!updatedUser) throw new NotFoundException('User not found');

      return {
        message: 'Add user credits successfully',
        data: updatedUser,
        statusCode: 200,
        date: new Date(),
      };
    } catch (error) {
      handleDefaultError(error);
    }
  }

  async sendVerificationEmail(userId: string): Promise<IResponseType> {
    try {
      const EXPIRATION_MINUTES = 10;
      const currentDate = new Date();
      if (!userId) throw new BadRequestException('User ID is required');

      const user = await this.prisma.user.findUnique({
        where: { id: userId },
      });

      if (!user) throw new NotFoundException('User not found');
      if (user.isActive)
        throw new BadRequestException('User is already active');

      // const token = this.jwtService.sign(
      //   { userId: user.id },
      //   { expiresIn: '1d' },
      // );

      // const verificationLink = `${this.configService.get('APP_URL')}/verify-email/${token}`;

      // Generate active code
      const checkCode = await this.prisma.activeCode.findFirst({
        where: {
          userId: user.id,
        },
      });

      let activeCode = checkCode?.code || generateSecureVerificationCode();

      if (!checkCode) {
        await this.prisma.activeCode.create({
          data: {
            userId: user.id,
            code: activeCode,
            createdAt: currentDate,
            expiresAt: addMinutes(currentDate, EXPIRATION_MINUTES),
          },
        });
      } else {
        const isExpired = isPast(new Date(checkCode.expiresAt));
        if (isExpired) {
          activeCode = generateSecureVerificationCode();
          await this.prisma.activeCode.update({
            where: { id: checkCode.id },
            data: {
              code: activeCode,
              createdAt: currentDate,
              expiresAt: addMinutes(currentDate, EXPIRATION_MINUTES),
            },
          });
        }
      }

      await this.emailService.sendActiveAccountEmail({
        email: user.email,
        context: {
          name: user.fullName,
          verification_code: activeCode, // TODO: Generate verification code
        },
      });

      return {
        message: 'Verification email sent successfully',
        data: null,
        statusCode: 204,
        date: new Date(),
      };
    } catch (error) {
      handleDefaultError(error);
    }
  }

  async userActiveByCode(
    userId: string,
    verificationData: UserActiveByCodeDto,
  ): Promise<IResponseType<UserDataType>> {
    try {
      if (!userId) throw new BadRequestException('User ID is required');

      const user = await this.prisma.user.findUnique({
        where: { id: userId },
      });
      if (!user) throw new NotFoundException('User not found');
      if (user.isActive) throw new ForbiddenException('User is already active');

      const checkCode = await this.prisma.activeCode.findFirst({
        where: {
          userId: user.id,
          code: verificationData.verifyCode,
        },
      });

      if (!checkCode) throw new ForbiddenException('Invalid verification code');

      const isExpired = isPast(new Date(checkCode.expiresAt));
      if (isExpired) throw new ForbiddenException('Verification code expired');

      await this.prisma.activeCode.delete({
        where: { id: checkCode.id },
      });

      const updatedUser = await this.prisma.user.update({
        where: { id: user.id },
        data: { isActive: true },
        select: userDataSelect,
      });

      return {
        message: 'User activated successfully',
        data: updatedUser,
        statusCode: 200,
        date: new Date(),
      };
    } catch (error) {
      handleDefaultError(error);
    }
  }

  async refreshToken(
    oldAccessToken: string,
  ): Promise<IResponseType<RefreshTokenResponseDto>> {
    try {
      const { sessionId, userId, username } =
        await this.jwt.verifyAsync<IDecodedAccecssTokenType>(oldAccessToken, {
          ignoreExpiration: true,
        });

      const key = v4();
      const accessToken = await this.customJwt.generateAccessToken({
        sessionId,
        userId,
        username,
        key,
      });
      const refreshToken = await this.customJwt.generateAccessToken(
        { sessionId, userId, username, key },
        { isRefreshToken: true },
      );

      const { exp } =
        await this.jwt.verifyAsync<IDecodedAccecssTokenType>(accessToken);

      await this.prisma.user.update({
        where: { id: userId },
        data: { refreshToken },
      });

      await this.prisma.userSession.update({
        where: { id: sessionId },
        data: {
          token: accessToken,
          expiresAt: fromUnixTime(+exp),
        },
      });

      return {
        message: 'Refresh token successfully generated',
        data: {
          accessToken,
        },
        statusCode: 200,
        date: new Date(),
      };
    } catch (error) {
      handleDefaultError(error);
    }
  }
}
