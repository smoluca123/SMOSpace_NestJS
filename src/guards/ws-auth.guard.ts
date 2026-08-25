import { Injectable, ExecutionContext } from '@nestjs/common';
import { AuthGuard } from '@nestjs/passport';
import { WsException } from '@nestjs/websockets';

@Injectable()
export class WsJwtGuard extends AuthGuard('jwt') {
  getRequest(context: ExecutionContext) {
    // Get the client socket from the context
    const wsContext = context.switchToWs();
    const client = wsContext.getClient();

    // Build a fake request object so the JWT strategy can process it.
    // Prefer the explicit accessToken auth field sent by the client; fall
    // back to the Authorization header only if absent.
    const rawToken =
      client.handshake.auth?.accessToken ||
      client.handshake.auth?.token ||
      client.handshake.headers?.accesstoken ||
      client.handshake.headers?.authorization;

    const token = rawToken?.replace('Bearer ', '');

    return {
      headers: {
        authorization: token ? `Bearer ${token}` : undefined,
        accesstoken: token,
      },
    };
  }

  handleRequest(err: any, user: any) {
    if (err || !user) {
      throw new WsException('Unauthorized');
    }
    // console.log(user);
    return user;
  }
}
