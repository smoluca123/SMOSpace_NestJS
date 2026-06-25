import { CanActivate, ExecutionContext, Injectable } from '@nestjs/common';
import { WsException } from '@nestjs/websockets';
import { Socket } from 'socket.io';
import { JwtService } from '@nestjs/jwt';

@Injectable()
export class WsJwtAuthGuard implements CanActivate {
  constructor(private jwtService: JwtService) {}

  async canActivate(context: ExecutionContext): Promise<boolean> {
    try {
      const client: Socket = context.switchToWs().getClient<Socket>();
      const token =
        client.handshake.auth.accessToken ||
        client.handshake.auth.token ||
        client.handshake.headers.accesstoken;

      if (!token) {
        throw new WsException('Unauthorized');
      }

      const payload = await this.jwtService.verifyAsync(
        token.replace('Bearer ', ''),
      );
      client.handshake.auth.userId = payload.sub;

      return true;
    } catch (err) {
      throw new WsException('Unauthorized');
    }
  }
}
