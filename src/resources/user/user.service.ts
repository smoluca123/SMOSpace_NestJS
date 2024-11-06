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

@Injectable()
export class UserService {
  constructor(private readonly prisma: PrismaService) {}
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

      const user = await this.prisma.user.findUnique({
        where: {
          id: userId,
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
}
