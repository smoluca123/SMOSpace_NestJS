import { CanActivate, ExecutionContext, Injectable } from '@nestjs/common';
import { WsException } from '@nestjs/websockets';
import { JwtTokenVerifyGuard } from './jwt-token-verify.guard';
import { Socket } from 'socket.io';
import { PrismaService } from 'src/prisma/prisma.service';
import { JwtService } from '@nestjs/jwt';

@Injectable()
export class WsJwtVerifyGuard implements CanActivate {
  private jwtTokenVerifyGuard: JwtTokenVerifyGuard;

  constructor(
    private readonly prismaService: PrismaService,
    private readonly jwt: JwtService,
  ) {
    // Tái sử dụng logic từ JwtTokenVerifyGuard
    this.jwtTokenVerifyGuard = new JwtTokenVerifyGuard(prismaService, jwt);
  }

  async canActivate(context: ExecutionContext): Promise<boolean> {
    const client = context.switchToWs().getClient<Socket>();
    try {
      // Tạo mock request object để tái sử dụng logic cũ
      const mockRequest = {
        headers: {
          accesstoken:
            client.handshake.auth.accessToken ||
            client.handshake.headers.accesstoken,
        },
      };

      // Tạo mock context để pass vào guard cũ
      const mockContext = {
        switchToHttp: () => ({
          getRequest: () => mockRequest,
        }),
      } as ExecutionContext;

      // Sử dụng logic từ guard cũ
      const result = await this.jwtTokenVerifyGuard.canActivate(mockContext);

      if (result) {
        // Lưu user data vào socket instance để sử dụng sau này
        client.data.user = mockRequest['userData'];
        client.data.decodedToken = mockRequest['decodedAccessToken'];
        return true;
      }
      return false;
    } catch (error) {
      // Convert HTTP exceptions sang WS exceptions
      throw new WsException(error.message || 'Unauthorized');
    }
  }
}
