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
} from 'src/interfaces/interface.global';
import { PrismaService } from 'src/prisma/prisma.service';
import { UserLoginDto } from 'src/resources/auth/dto/UserLogin.dto';
import * as bcrypt from 'bcrypt';
import { v4 as uuidv4 } from 'uuid';
import { ConfigService } from '@nestjs/config';

import { UserRegisterDto } from 'src/resources/auth/dto/UserRegister.dto';
import { JwtServiceCustom } from 'src/jwt/jwt.service';
import { JwtService } from '@nestjs/jwt';
import { Response } from 'express';
import { CookieName } from 'src/global/enums.global';
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
    response: Response,
    userAgent: string,
    ipAddress: string,
  ): Promise<IResponseType<UserDataType>> {
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
      const accessToken = await this.jwtCustom.generateAccessToken({
        userId: checkUser.id,
        username: checkUser.username,
        key,
      });
      const refreshToken = await this.jwtCustom.generateAccessToken(
        {
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
      const sessionResult = await this.setAuthSession({
        accessToken,
        userAgent,
        ipAddress,
      });
      response.cookie(CookieName.ACCESS_TOKEN, accessToken, {
        httpOnly: true,
        secure: this.config.get('NODE_ENV') === 'production',
        sameSite: 'strict',
      });
      response.cookie(CookieName.SESSION_ID, sessionResult.data.id, {
        httpOnly: true,
        secure: this.config.get('NODE_ENV') === 'production',
        sameSite: 'strict',
      });

      return {
        message: 'Logged in successfully',
        data: resultUser,
        statusCode: 200,
        date: new Date(),
      };
    } catch (error) {
      handleDefaultError(error);
    }
  }

  async authRegister(
    credentials: UserRegisterDto,
    res: Response,
    userAgent: string,
    ipAddress: string,
  ): Promise<IResponseType<UserDataType>> {
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
      const accessToken = await this.jwtCustom.generateAccessToken({
        userId,
        username,
        key,
      });
      const refreshToken = await this.jwtCustom.generateAccessToken(
        {
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
      const sessionResult = await this.setAuthSession({
        accessToken,
        userAgent,
        ipAddress,
      });

      res.cookie(CookieName.ACCESS_TOKEN, accessToken, {
        httpOnly: true,
        secure: this.config.get('NODE_ENV') === 'production',
        sameSite: 'strict',
      });
      res.cookie(CookieName.SESSION_ID, sessionResult.data.id, {
        httpOnly: true,
        secure: this.config.get('NODE_ENV') === 'production',
        sameSite: 'strict',
      });

      return {
        message: 'User registered successfully',
        data: resultUser,
        statusCode: 201,
        date: new Date(),
      };
    } catch (error) {
      handleDefaultError(error);
    }
  }

  async authLogout(
    sessionId: string,
    decodedAccessToken: IDecodedAccecssTokenType,
    response: Response,
  ): Promise<IResponseType> {
    try {
      const { userId } = decodedAccessToken;

      await this.prisma.user.update({
        where: { id: userId },
        data: { refreshToken: null },
      });

      // await this.prisma.user_sessions.delete({
      //   where: {
      //     id: sessionId,
      //     user_id: userId,
      //     token: accessToken,
      //     user_agent: userAgent,
      //   },
      // });

      // Delete session
      await this.removeAuthSession(sessionId);
      response.clearCookie(CookieName.ACCESS_TOKEN);
      response.clearCookie(CookieName.SESSION_ID);

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
    sessionId: string,
    decodedAccessToken: IDecodedAccecssTokenType,
    response: Response,
  ): Promise<
    IResponseType<{ id: string; expiresAt: Date; user: UserDataType }>
  > {
    try {
      const sessionResult = await this.prisma.userSession.findUnique({
        where: { id: sessionId },
        select: { id: true, expiresAt: true, user: { select: userDataSelect } },
      });

      if (
        !sessionResult ||
        sessionResult.user.id !== decodedAccessToken.userId
      ) {
        response.clearCookie(CookieName.ACCESS_TOKEN);
        response.clearCookie(CookieName.SESSION_ID);
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
    accessToken,
    ipAddress,
    userAgent,
    payload,
  }: {
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

  // async getLyric(trackId: string): Promise<IResponseType> {
  //   try {
  //     // const spotClient = new LyricsClient(this.config.get('SPOTIFY_COOKIE'));
  //     const { accessToken } = await fetch(
  //       'https://open.spotify.com/get_access_token',
  //       {
  //         headers: {
  //           Cookie: this.config.get('SPOTIFY_COOKIE'),
  //           'User-Agent':
  //             'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/116.0.0.0 Safari/537.36',
  //         },
  //       },
  //     ).then((res) => res.json());

  //     const data = await fetch(
  //       `https://spclient.wg.spotify.com/color-lyrics/v2/track/${trackId}?format=json&vocalRemoval=false&market=from_token`,
  //       {
  //         headers: {
  //           'app-platform': 'WebPlayer',
  //           Authorization: `Bearer ${accessToken}`,
  //           'User-Agent':
  //             'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/129.0.0.0 Safari/537.36 Edg/129.0.0.0',
  //         },
  //       },
  //     ).then((res) => res.text());

  //     return {
  //       data: JSON.parse(data),
  //       message: 'Get lyric successfully',
  //       statusCode: 200,
  //       date: new Date(),
  //     };
  //   } catch (error) {
  //     handleDefaultError(error);
  //   }
  // }
}
