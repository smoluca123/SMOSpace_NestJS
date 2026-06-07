import { Injectable, ExecutionContext } from '@nestjs/common';
import { AuthGuard } from '@nestjs/passport';
import { WsException } from '@nestjs/websockets';

@Injectable()
export class WsJwtGuard extends AuthGuard('jwt') {
  getRequest(context: ExecutionContext) {
    // Get the client socket from the context
    const wsContext = context.switchToWs();
    const client = wsContext.getClient();

    // Build a fake request object so the JWT strategy can process it
    const authToken = client.handshake.headers.authorization;

    return {
      headers: {
        authorization: authToken,
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
