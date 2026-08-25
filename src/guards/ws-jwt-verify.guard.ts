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
    // Reuse the logic from JwtTokenVerifyGuard
    this.jwtTokenVerifyGuard = new JwtTokenVerifyGuard(prismaService, jwt);
  }

  async canActivate(context: ExecutionContext): Promise<boolean> {
    const client = context.switchToWs().getClient<Socket>();
    try {
      // If user data is already populated in handleConnection, allow immediately
      if (client.data?.user?.id) {
        return true;
      }

      const rawToken =
        client.handshake.auth?.accessToken ||
        client.handshake.auth?.token ||
        client.handshake.headers?.accesstoken ||
        client.handshake.headers?.authorization;

      if (!rawToken) {
        throw new WsException('Unauthorized');
      }

      // Build a mock request object to reuse the existing logic
      const mockRequest = {
        headers: {
          accesstoken: rawToken.replace('Bearer ', ''),
        },
      };

      // Build a mock context to pass into the existing guard
      const mockContext = {
        switchToHttp: () => ({
          getRequest: () => mockRequest,
        }),
      } as ExecutionContext;

      // Reuse the logic from the existing guard
      const result = await this.jwtTokenVerifyGuard.canActivate(mockContext);

      if (result) {
        // Store user data on the socket instance for later use
        client.data.user = mockRequest['userData'];
        client.data.decodedToken = mockRequest['decodedAccessToken'];
        return true;
      }
      return false;
    } catch (error) {
      // Convert HTTP exceptions to WS exceptions
      throw new WsException(error.message || 'Unauthorized');
    }
  }
}
