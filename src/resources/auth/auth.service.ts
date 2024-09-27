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
// import { Response } from 'express';

@Injectable()
export class AuthService {
  constructor(
    private readonly prisma: PrismaService,
    private readonly config: ConfigService,
    private readonly jwtCustom: JwtServiceCustom,
    private readonly jwt: JwtService,
  ) {}
  async authLogin(
    credentials: UserLoginDto,
    response: Response,
    userAgent: string,
    ipAddress: string,
  ): Promise<IResponseType> {
    try {
      const { username, password } = credentials;

      const checkUser = await this.prisma.user.findFirst({
        where: { OR: [{ username }, { email: username }] },
        include: { user_type: true },
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
          refresh_token: refreshToken,
        },
      });

      // eslint-disable-next-line @typescript-eslint/no-unused-vars
      const { refresh_token, type, password: _pw, ...resultUser } = checkUser;

      // Set the session
      response.cookie('accessToken', accessToken);
      await this.setAuthSession({ accessToken, userAgent, ipAddress });

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
    res: Response,
    userAgent: string,
    ipAddress: string,
  ): Promise<IResponseType> {
    try {
      const {
        username,
        email,
        age,
        display_name,
        full_name,
        password,
        phone_number,
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

      /*   eslint-disable @typescript-eslint/no-unused-vars */
      const {
        password: _pw,
        refresh_token,
        type,
        ...resultUser
      } = await this.prisma.user.create({
        data: {
          id: userId,
          username,
          email,
          age,
          display_name,
          full_name,
          password: await bcrypt.hash(password, 10),
          phone_number,
          refresh_token: refreshToken,
          is_active: 0,
          created_at: new Date(),
        },
        include: {
          user_type: true,
        },
      });
      /*   eslint-enable @typescript-eslint/no-unused-vars*/

      // Set the session
      res.cookie('accessToken', accessToken);
      await this.setAuthSession({ accessToken, userAgent, ipAddress });

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
    accessToken: string,
    userAgent: string,
  ): Promise<IResponseType> {
    try {
      const { userId } = decodedAccessToken;

      await this.prisma.user.update({
        where: { id: userId },
        data: { refresh_token: null },
      });

      await this.prisma.user_sessions.delete({
        where: {
          user_id: userId,
          token: accessToken,
          user_agent: userAgent,
        },
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
  }): Promise<IResponseType> {
    try {
      const { exp, userId } = this.jwt.verify(
        accessToken,
      ) as IDecodedAccecssTokenType;
      const currentDate = new Date();

      const checkUserSession = await this.prisma.user_sessions.findFirst({
        where: {
          AND: {
            user_id: userId,
            user_agent: userAgent,
            ip_address: ipAddress,
          },
        },
        include: { user: true },
      });

      if (!checkUserSession) {
        await this.prisma.user_sessions.create({
          data: {
            ip_address: ipAddress,
            token: accessToken,
            created_at: currentDate,
            expires_at: new Date(exp),
            last_activity: currentDate,
            user_id: userId,
            user_agent: userAgent,
            payload: JSON.stringify(payload),
          },
        });
      }

      return {
        message: 'Set session successfully',
        data: null,
        statusCode: 201,
        date: new Date(),
      };
    } catch (error) {
      handleDefaultError(error);
    }
  }
}
