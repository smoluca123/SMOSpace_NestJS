import { ExecutionContext, Injectable } from '@nestjs/common';
import { JwtService } from '@nestjs/jwt';
import { PrismaService } from 'src/prisma/prisma.service';
import { Socket } from 'socket.io';
import { JwtTokenVerifyGuard } from 'src/guards/jwt-token-verify.guard';
import { UserDataType } from 'src/libs/prisma-types';
import { IDecodedAccecssTokenType } from 'src/interfaces/interfaces.global';
import { RedisService } from '@liaoliaots/nestjs-redis';
import { Redis } from 'ioredis';

@Injectable()
export class WsAuthMiddleware {
  private jwtTokenVerifyGuard: JwtTokenVerifyGuard;
  private redis: Redis | null;

  constructor(
    private readonly jwtService: JwtService,
    private readonly prismaService: PrismaService,
    private readonly redisService: RedisService,
  ) {
    this.jwtTokenVerifyGuard = new JwtTokenVerifyGuard(
      prismaService,
      jwtService,
    );
    this.redis = this.redisService.getOrThrow();
  }

  async use(socket: Socket, next: (err?: Error) => void) {
    try {
      const token =
        socket.handshake.auth.accessToken ||
        socket.handshake.headers.accesstoken;

      if (!token) return next();

      //   const decodedToken = this.jwtService.verify(token);
      //   const user = await this.prismaService.user.findUnique({
      //     where: {
      //       id: decodedToken.userId,
      //       username: decodedToken.username,
      //     },
      //   });

      const cachedToken: {
        user: UserDataType;
        decodedToken: IDecodedAccecssTokenType;
      } = JSON.parse(await this.redis.get(`accesstoken:${token}`));

      if (!cachedToken) {
        const mockRequest = {
          headers: {
            accesstoken: token,
          },
        };

        // Tạo mock context để pass vào guard cũ
        const mockContext = {
          switchToHttp: () => ({
            getRequest: () => mockRequest,
          }),
        } as ExecutionContext;
        const result = await this.jwtTokenVerifyGuard.canActivate(mockContext);

        if (!result) {
          next(new Error('Unauthorized'));
        }

        // Lưu user data vào socket instance để sử dụng sau này
        socket.data.user = mockRequest['userData'];
        socket.data.decodedToken = mockRequest['decodedAccessToken'];

        // cache user redis
        await this.redis.set(
          `accesstoken:${token}`,
          JSON.stringify({
            user: mockRequest['userData'],
            decodedToken: mockRequest['decodedAccessToken'],
          }),
          'EX',
          300,
        );
        return next();
      }
      console.log(cachedToken);
      socket.data.user = cachedToken['user'];
      socket.data.decodedToken = cachedToken['decodedToken'];
      next();
    } catch (error) {
      next(new Error('Unauthorized'));
    }
  }
}
