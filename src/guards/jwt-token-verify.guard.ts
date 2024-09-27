import {
  Injectable,
  CanActivate,
  ExecutionContext,
  UnauthorizedException,
  ForbiddenException,
} from '@nestjs/common';
import { Observable } from 'rxjs';
import { PrismaService } from 'src/prisma/prisma.service';
import { JwtService } from '@nestjs/jwt';
import { Request as RequestExpress } from 'express';
import { IDecodedAccecssTokenType } from 'src/interfaces/interface.global';

@Injectable()
export class JwtTokenVerifyGuard implements CanActivate {
  constructor(
    private readonly prismaService: PrismaService,
    private readonly jwt: JwtService,
  ) {}

  canActivate(
    context: ExecutionContext,
  ): boolean | Promise<boolean> | Observable<boolean> {
    interface RequestNewType extends RequestExpress {
      decodedAccessToken?: IDecodedAccecssTokenType;
    }
    const request = context.switchToHttp().getRequest() as RequestNewType;
    if (!request.cookies['accessToken']) {
      throw new UnauthorizedException('Access token is missing');
    }
    let accessToken = request.cookies['accessToken'];

    if (accessToken.includes('Bearer')) {
      accessToken = accessToken.split('Bearer ')[1];
    }

    if (!accessToken) {
      throw new UnauthorizedException('Access token is missing');
    }

    let decodedAccessToken: IDecodedAccecssTokenType;
    try {
      decodedAccessToken = this.jwt.verify(accessToken);
      request.decodedAccessToken = decodedAccessToken;
    } catch (error) {
      throw new UnauthorizedException('Invalid access token');
    }

    return this.validateTokenKeyMatch(
      decodedAccessToken,
      accessToken,
      request.headers['user-agent'],
    );
  }

  private async validateTokenKeyMatch(
    decodedAccessToken: IDecodedAccecssTokenType,
    accessToken: string,
    userAgent: string,
  ): Promise<boolean> {
    if (!decodedAccessToken.userId || !decodedAccessToken.username)
      throw new UnauthorizedException(
        'Invalid access token or has been modified',
      );

    const user = await this.prismaService.user.findUnique({
      where: {
        id: decodedAccessToken.userId,
        username: decodedAccessToken.username,
      },
    });

    const userSession = await this.prismaService.user_sessions.findFirst({
      where: {
        AND: [
          {
            user_id: decodedAccessToken.userId,
            token: accessToken,
            user_agent: userAgent,
          },
        ],
      },
    });

    if (!userSession) {
      throw new UnauthorizedException('Invalid login session');
    }

    if (!user || !user.refresh_token) {
      throw new UnauthorizedException('User not found or has been deleted');
    }
    if (user.is_banned) throw new ForbiddenException('User has been banned');

    let decodedRefreshToken: any;
    try {
      decodedRefreshToken = this.jwt.verify(user.refresh_token);
    } catch (error) {
      throw new UnauthorizedException('Invalid refresh token');
    }
    if (decodedAccessToken.key !== decodedRefreshToken.key) {
      throw new UnauthorizedException('Tokens have been leaked');
    }
    return true;
  }
}
