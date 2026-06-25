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
    const accessToken =
      client.handshake.auth.accessToken || client.handshake.headers.accesstoken;

    return {
      headers: {
        accesstoken: accessToken,
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
