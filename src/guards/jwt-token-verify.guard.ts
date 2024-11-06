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
import { CookieName } from 'src/global/enums.global';

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
      sessionId?: string;
    }
    const request = context.switchToHttp().getRequest() as RequestNewType;

    const sessionId: string = request.cookies[CookieName.SESSION_ID];
    if (!sessionId) throw new UnauthorizedException('Session ID is missing');

    let accessToken =
      request.cookies[CookieName.ACCESS_TOKEN] ||
      request.headers['authorization'];
    accessToken = accessToken.replace('Bearer ', '');

    if (!accessToken) {
      throw new UnauthorizedException('Access token is missing');
    }

    let decodedAccessToken: IDecodedAccecssTokenType;
    try {
      decodedAccessToken = this.jwt.verify(accessToken);
      decodedAccessToken.originalToken = accessToken;
      request.decodedAccessToken = decodedAccessToken;
      request.sessionId = sessionId;
    } catch (error) {
      throw new UnauthorizedException('Invalid access token');
    }

    return this.validateTokenKeyMatch(sessionId, decodedAccessToken);
  }

  private async validateTokenKeyMatch(
    sessionId: string,
    decodedAccessToken: IDecodedAccecssTokenType,
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

    const userSession = await this.prismaService.userSession.findFirst({
      where: {
        AND: {
          id: sessionId,
          token: decodedAccessToken.originalToken,
        },
      },
    });
    if (!userSession) {
      throw new UnauthorizedException('Invalid login session');
    }

    if (!user || !user.refreshToken) {
      throw new UnauthorizedException('User not found or has been deleted');
    }
    if (user.isBanned) throw new ForbiddenException('User has been banned');

    // let decodedRefreshToken: any;
    // try {
    //   decodedRefreshToken = this.jwt.verify(user.refreshToken);
    // } catch (error) {
    //   throw new UnauthorizedException('Invalid refresh token');
    // }
    // if (decodedAccessToken.key !== decodedRefreshToken.key) {
    //   throw new UnauthorizedException('Tokens have been leaked');
    // }
    return true;
  }
}
