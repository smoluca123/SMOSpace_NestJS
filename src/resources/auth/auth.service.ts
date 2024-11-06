import {
  ConflictException,
  Injectable,
  NotFoundException,
  UnauthorizedException,
} from '@nestjs/common';
import { handleDefaultError } from 'src/global/functions.global';
import {
  IDecodedAccecssTokenType,
  IResponseType,
} from 'src/interfaces/interfaces.global';
import { PrismaService } from 'src/prisma/prisma.service';
import { UserLoginDto } from 'src/resources/auth/dto/UserLogin.dto';
import * as bcrypt from 'bcrypt';
import { v4 as uuidv4 } from 'uuid';
import { ConfigService } from '@nestjs/config';

import { UserRegisterDto } from 'src/resources/auth/dto/UserRegister.dto';
import { JwtServiceCustom } from 'src/jwt/jwt.service';
import { JwtService } from '@nestjs/jwt';
import { HttpService } from '@nestjs/axios';
import {
  userDataSelect,
  UserDataType,
  userTypeDataSelect,
} from 'src/libs/prisma-types';
import { UserSession } from '@prisma/client';
import { fromUnixTime } from 'date-fns';
// import { Response } from 'express';

@Injectable()
export class AuthService {
  constructor(
    private readonly prisma: PrismaService,
    private readonly config: ConfigService,
    private readonly jwtCustom: JwtServiceCustom,
    private readonly jwt: JwtService,
    private readonly httpService: HttpService,
  ) {}
  async authLogin(
    credentials: UserLoginDto,
    userAgent: string,
    ipAddress: string,
  ): Promise<IResponseType<UserDataType & { accessToken: string }>> {
    try {
      const { username, password } = credentials;

      const checkUser = await this.prisma.user.findFirst({
        where: { OR: [{ username }, { email: username }] },
        include: { userType: true },
      });

      if (!checkUser) throw new NotFoundException('User not found');

      const isMatchPassword = await bcrypt.compare(
        password,
        checkUser.password,
      );
      if (!isMatchPassword)
        throw new UnauthorizedException('Incorrect password');

      // Generate JWT
      const key = uuidv4();
      const sessionId = uuidv4();
      const accessToken = await this.jwtCustom.generateAccessToken({
        sessionId,
        userId: checkUser.id,
        username: checkUser.username,
        key,
      });
      const refreshToken = await this.jwtCustom.generateAccessToken(
        {
          sessionId,
          userId: checkUser.id,
          username: checkUser.username,
          key,
        },
        { isRefreshToken: true },
      );

      await this.prisma.user.update({
        where: { id: checkUser.id },
        data: {
          refreshToken: refreshToken,
        },
      });

      /* eslint-disable @typescript-eslint/no-unused-vars*/
      const {
        refreshToken: _rfToken,
        type,
        password: _pw,
        ...resultUser
      } = checkUser;
      /* eslint-enable @typescript-eslint/no-unused-vars*/

      // Set the session
      await this.setAuthSession({
        sessionId,
        accessToken,
        userAgent,
        ipAddress,
      });

      return {
        message: 'Logged in successfully',
        data: { ...resultUser, accessToken },
        statusCode: 200,
        date: new Date(),
      };
    } catch (error) {
      handleDefaultError(error);
    }
  }

  async authRegister(
    credentials: UserRegisterDto,
    userAgent: string,
    ipAddress: string,
  ): Promise<IResponseType<UserDataType & { accessToken: string }>> {
    try {
      const {
        username,
        email,
        age,
        displayName,
        fullName,
        password,
        phoneNumber,
      } = credentials;
      const checkUser = await this.prisma.user.findFirst({
        where: { username },
      });

      if (checkUser) throw new ConflictException('Username already exists');
      if (checkUser && email === checkUser?.email)
        throw new ConflictException('Email already exists');

      //   Generate JWT
      const userId = uuidv4();
      const key = uuidv4();
      const sessionId = uuidv4();
      const accessToken = await this.jwtCustom.generateAccessToken({
        sessionId,
        userId,
        username,
        key,
      });
      const refreshToken = await this.jwtCustom.generateAccessToken(
        {
          sessionId,
          userId,
          username,
          key,
        },
        { isRefreshToken: true },
      );

      /*   eslint-disable @typescript-eslint/no-unused-vars */
      const {
        password: _pw,
        refreshToken: _rfToken,
        type,
        ...resultUser
      } = await this.prisma.user.create({
        data: {
          id: userId,
          username,
          email,
          age,
          displayName,
          fullName,
          password: await bcrypt.hash(password, 10),
          phoneNumber,
          refreshToken,
          isActive: false,
          createdAt: new Date(),
          userType: {
            connect: {
              id: '588b1a65-426a-468c-9365-dc1c9b851a79',
            },
          },
        },
        include: {
          userType: {
            select: userTypeDataSelect,
          },
        },
      });
      /*   eslint-enable @typescript-eslint/no-unused-vars*/

      // Set the session
      await this.setAuthSession({
        sessionId,
        accessToken,
        userAgent,
        ipAddress,
      });

      return {
        message: 'User registered successfully',
        data: { ...resultUser, accessToken },
        statusCode: 201,
        date: new Date(),
      };
    } catch (error) {
      handleDefaultError(error);
    }
  }

  async authLogout(
    decodedAccessToken: IDecodedAccecssTokenType,
  ): Promise<IResponseType> {
    try {
      const { userId, sessionId } = decodedAccessToken;

      await this.prisma.user.update({
        where: { id: userId },
        data: { refreshToken: null },
      });

      // Delete session
      await this.removeAuthSession(sessionId);

      return {
        message: 'Logged out successfully',
        data: null,
        statusCode: 204,
        date: new Date(),
      };
    } catch (error) {
      handleDefaultError(error);
    }
  }

  async authValidateSession(
    decodedAccessToken: IDecodedAccecssTokenType,
  ): Promise<
    IResponseType<{ id: string; expiresAt: Date; user: UserDataType }>
  > {
    try {
      const sessionResult = await this.prisma.userSession.findUnique({
        where: { id: decodedAccessToken.sessionId },
        select: { id: true, expiresAt: true, user: { select: userDataSelect } },
      });

      if (
        !sessionResult ||
        sessionResult.user.id !== decodedAccessToken.userId
      ) {
        throw new UnauthorizedException('Invalid session or expired session');
      }

      return {
        message: 'Session is available',
        data: sessionResult,
        statusCode: 200,
        date: new Date(),
      };
    } catch (error) {
      handleDefaultError(error);
    }
  }

  //   ----------------- Utils
  async setAuthSession({
    sessionId,
    accessToken,
    ipAddress,
    userAgent,
    payload,
  }: {
    sessionId: string;
    accessToken: string;
    userAgent: string;
    ipAddress: string;
    payload?: JSON;
  }): Promise<IResponseType<UserSession>> {
    try {
      const { exp, userId } = this.jwt.verify(
        accessToken,
      ) as IDecodedAccecssTokenType;
      const currentDate = new Date();
      const expiresAt = fromUnixTime(+exp);

      const checkUserSession = await this.prisma.userSession.findFirst({
        where: {
          AND: {
            id: sessionId,
            userId: userId,
            userAgent: userAgent,
          },
        },
        include: { user: true },
      });

      const userSession = await this.prisma.userSession.upsert({
        where: {
          id: checkUserSession?.id || '',
        },
        create: {
          id: sessionId,
          ipAddress: ipAddress,
          token: accessToken,
          createdAt: currentDate,
          expiresAt,
          lastActivity: currentDate,
          userId: userId,
          userAgent: userAgent,
          payload: JSON.stringify(payload),
        },
        update: {
          lastActivity: currentDate,
          expiresAt,
          token: accessToken,
          payload: JSON.stringify(payload),
        },
        include: {
          user: {
            select: userDataSelect,
          },
        },
      });

      // if (!checkUserSession) {
      //   sessionResult = await this.prisma.userSession.create({
      //     data: {
      //       ipAddress: ipAddress,
      //       token: accessToken,
      //       createdAt: currentDate,
      //       expiresAt: new Date(exp),
      //       lastActivity: currentDate,
      //       userId: userId,
      //       userAgent: userAgent,
      //       payload: JSON.stringify(payload),
      //     },
      //   });
      // } else {
      //   sessionResult = await this.prisma.userSession.update({
      //     where: { id: checkUserSession.id },
      //     data: {
      //       lastActivity: currentDate,
      //       token: accessToken,
      //       payload: JSON.stringify(payload),
      //     },
      //   });
      // }
      return {
        message: 'Set session successfully',
        data: {
          ...userSession,
        },
        statusCode: 201,
        date: new Date(),
      };
    } catch (error) {
      handleDefaultError(error);
    }
  }

  async removeAuthSession(sessionId: string): Promise<IResponseType> {
    try {
      await this.prisma.userSession.delete({
        where: { id: sessionId },
      });

      return {
        message: 'Removed session successfully',
        data: null,
        statusCode: 204,
        date: new Date(),
      };
    } catch (error) {
      handleDefaultError(error);
    }
  }
}
