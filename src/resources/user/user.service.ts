import {
  BadRequestException,
  Injectable,
  NotFoundException,
} from '@nestjs/common';
import { handleDefaultError } from 'src/global/functions.global';
import {
  IDecodedAccecssTokenType,
  IResponseType,
} from 'src/interfaces/interfaces.global';
import { userDataSelect, UserDataType } from 'src/libs/prisma-types';
import { PrismaService } from 'src/prisma/prisma.service';
import { BanUserDto, UpdateProfileDto } from 'src/resources/user/dto/user.dto';
import * as bcrypt from 'bcrypt';
import { ConfigService } from '@nestjs/config';

@Injectable()
export class UserService {
  constructor(
    private readonly prisma: PrismaService,
    private readonly config: ConfigService,
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
}
