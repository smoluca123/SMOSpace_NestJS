import {
  BadRequestException,
  ConflictException,
  ForbiddenException,
  Injectable,
  NotFoundException,
  UnauthorizedException,
} from '@nestjs/common';
import { handleDefaultError } from 'src/global/functions.global';
import {
  IDecodedAccecssTokenType,
  IResponseType,
  IUserDataWithAccessToken,
} from 'src/interfaces/interfaces.global';
import { PrismaService } from 'src/prisma/prisma.service';
import { UserLoginDto } from 'src/resources/auth/dto/UserLogin.dto';
import * as bcrypt from 'bcryptjs';
import { v4 as uuidv4, v4 } from 'uuid';

import { UserRegisterDto } from 'src/resources/auth/dto/UserRegister.dto';
import { JwtServiceCustom } from 'src/jwt/jwt.service';

import {
  userDataSelect,
  UserDataType,
  userSessionDataSelect,
  UserSessionDataType,
} from 'src/libs/prisma-types';
import { UserSession } from '@prisma/client';
import { addDays, isPast } from 'date-fns';
import { Response } from 'express';
import { AUTH_CONSTANTS } from 'src/resources/auth/auth.constants';
import { JwtService } from '@nestjs/jwt';
// import { Response } from 'express';

@Injectable()
export class AuthService {
  constructor(
    private readonly prisma: PrismaService,
    private readonly jwt: JwtService,
    private readonly jwtCustom: JwtServiceCustom,
  ) {}
  async authLogin({
    credentials,
    userAgent,
    ipAddress,
  }: {
    credentials: UserLoginDto;
    userAgent: string;
    ipAddress: string;
    response: Response;
  }): Promise<
    IResponseType<
      UserDataType & {
        accessToken: string;
      }
    >
  > {
    try {
      const { username, password } = credentials;

      const checkUser = await this.prisma.user.findFirst({
        where: { OR: [{ username }, { email: username }] },
        include: { userType: true },
      });

      if (!checkUser) throw new NotFoundException('User not found');
      if (checkUser.isBanned) throw new UnauthorizedException('User is banned');

      const isMatchPassword = await bcrypt.compare(
        password,
        checkUser.password,
      );
      if (!isMatchPassword)
        throw new UnauthorizedException('Incorrect password');

      /* eslint-disable @typescript-eslint/no-unused-vars*/
      const {
        refreshToken: _rfToken,
        type,
        password: _pw,
        ...resultUser
      } = checkUser;
      /* eslint-enable @typescript-eslint/no-unused-vars*/

      // Generate JWT
      const { accessToken, refreshToken } = await this.generateAuthTokens({
        user: checkUser,
      });

      // Update user record with refresh token after registration
      // This allows the user to maintain their session and perform authenticated requests
      // The refresh token is used to generate new access tokens when they expire
      await this.prisma.user.update({
        where: { id: checkUser.id },
        data: {
          refreshToken,
        },
      });

      // Set auth session
      await this.setAuthSession({
        accessToken,
        ipAddress,
        userAgent,
        userData: checkUser,
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
  ): Promise<
    IResponseType<
      UserDataType & {
        accessToken: string;
      }
    >
  > {
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

      /*   eslint-disable @typescript-eslint/no-unused-vars */
      const createdUser = await this.prisma.user.create({
        data: {
          username,
          email,
          age,
          displayName,
          fullName,
          password: await bcrypt.hash(password, 10),
          phoneNumber,
          isActive: false,
          createdAt: new Date(),
          userType: {
            connect: {
              id: AUTH_CONSTANTS.DEFAULT_USER_TYPE_ID,
            },
          },
        },
        select: userDataSelect,
      });
      /*   eslint-enable @typescript-eslint/no-unused-vars*/

      // Generate JWT
      const { accessToken, refreshToken } = await this.generateAuthTokens({
        user: createdUser,
      });

      // Update user record with refresh token after registration
      // This allows the user to maintain their session and perform authenticated requests
      // The refresh token is used to generate new access tokens when they expire
      await this.prisma.user.update({
        where: { id: createdUser.id },
        data: {
          refreshToken,
        },
      });

      // Set the session
      await this.setAuthSession({
        accessToken,
        userData: createdUser,
        userAgent,
        ipAddress,
      });

      return {
        message: 'User registered successfully',
        data: { ...createdUser, accessToken },
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
      const { userId, originalToken } = decodedAccessToken;

      await this.prisma.user.update({
        where: { id: userId },
        data: { refreshToken: null },
      });

      // Delete session
      await this.removeAuthSession({
        accessToken: originalToken,
      });

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
    IResponseType<
      Omit<UserSessionDataType, 'token'> & {
        user: IUserDataWithAccessToken;
      }
    >
  > {
    try {
      // eslint-disable-next-line @typescript-eslint/no-unused-vars
      const { token, user, ...sessionResult } =
        await this.prisma.userSession.findUnique({
          where: { token: decodedAccessToken.originalToken },
          select: userSessionDataSelect,
        });

      if (!sessionResult || user.id !== decodedAccessToken.userId) {
        throw new UnauthorizedException('Invalid session or expired session');
      }

      user['accessToken'] = decodedAccessToken.originalToken;

      return {
        message: 'Session is available',
        data: {
          ...sessionResult,
          user: user as IUserDataWithAccessToken,
        },
        statusCode: 200,
        date: new Date(),
      };
    } catch (error) {
      handleDefaultError(error);
    }
  }

  /**
   * Renew user's login session
   * @param oldAccessToken - Old token that needs to be renewed
   * @returns New session information of the user
   */
  async renewSession(oldAccessToken: string): Promise<
    IResponseType<
      Omit<UserSessionDataType, 'token'> & {
        user: IUserDataWithAccessToken;
      }
    >
  > {
    try {
      if (!oldAccessToken)
        throw new BadRequestException('Access token is required');

      // Get current timestamp
      const currentDate = new Date();

      // Check if old session exists
      const checkSession = await this.prisma.userSession.findUnique({
        where: { token: oldAccessToken },
      });

      // Decode old token to get user information
      const { userId, username } = await this.jwt.verifyAsync<
        Omit<IDecodedAccecssTokenType, 'originalToken'>
      >(oldAccessToken, {
        ignoreExpiration: true,
      });

      // Validate session
      if (!checkSession || checkSession.userId !== userId)
        throw new ForbiddenException('Invalid session');
      if (isPast(new Date(checkSession.expiresAt)))
        throw new ForbiddenException('Session expired');

      // Generate new key for token
      const key = v4();

      // Generate new access token and refresh token
      const accessToken = await this.jwtCustom.generateAccessToken({
        userId,
        username,
        key,
      });
      const refreshToken = await this.jwtCustom.generateAccessToken(
        { userId, username, key },
        { isRefreshToken: true },
      );

      // Update user with new refresh token
      await this.prisma.user.update({
        where: { id: userId },
        data: { refreshToken },
      });

      // Update session with new token
      // eslint-disable-next-line @typescript-eslint/no-unused-vars
      const { token, user, ...newSession } =
        await this.prisma.userSession.update({
          where: { token: oldAccessToken },
          data: {
            token: accessToken,
            expiresAt: addDays(currentDate, AUTH_CONSTANTS.SESSION_EXPIRES),
          },
          select: userSessionDataSelect,
        });

      // Add access token to user information
      user['accessToken'] = accessToken;

      // Return result
      return {
        message: 'Refresh token successfully generated',
        data: {
          ...newSession,
          user: user as IUserDataWithAccessToken,
        },
        statusCode: 200,
        date: new Date(),
      };
    } catch (error) {
      handleDefaultError(error);
    }
  }

  //   ----------------- Utils
  async setAuthSession({
    accessToken,
    userData,
    ipAddress,
    userAgent,
    payload,
  }: {
    accessToken: string;
    userData: UserDataType;
    userAgent: string;
    ipAddress: string;
    payload?: JSON;
  }): Promise<IResponseType<UserSession>> {
    try {
      const checkUserSession = await this.prisma.userSession.findFirst({
        where: {
          AND: {
            userId: userData.id,
            userAgent: userAgent,
          },
        },
        include: { user: true },
      });

      const currentDate = new Date();
      const expiresAt = addDays(currentDate, AUTH_CONSTANTS.SESSION_EXPIRES); // 24 hours

      const userSession = await this.prisma.userSession.upsert({
        where: {
          id: checkUserSession?.id || '',
        },
        create: {
          token: accessToken,
          ipAddress,
          expiresAt,
          lastActivity: currentDate,
          userId: userData.id,
          userAgent: userAgent,
          payload: JSON.stringify(payload),
        },
        update: {
          token: accessToken,
          ipAddress,
          lastActivity: currentDate,
          expiresAt,
          payload: JSON.stringify(payload),
        },
        include: {
          user: {
            select: userDataSelect,
          },
        },
      });

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

  async removeAuthSession({
    accessToken,
  }: {
    accessToken: string;
  }): Promise<IResponseType> {
    try {
      await this.prisma.userSession.delete({
        where: { token: accessToken },
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

  async generateAuthTokens({ user }: { user: UserDataType }): Promise<{
    accessToken: string;
    refreshToken: string;
  }> {
    try {
      const key = uuidv4();
      const accessToken = await this.jwtCustom.generateAccessToken({
        userId: user.id,
        username: user.username,
        key,
      });
      const refreshToken = await this.jwtCustom.generateAccessToken(
        {
          userId: user.id,
          username: user.username,
          key,
        },
        { isRefreshToken: true },
      );

      return {
        accessToken,
        refreshToken,
      };
    } catch (error) {
      handleDefaultError(error);
    }
  }
}
