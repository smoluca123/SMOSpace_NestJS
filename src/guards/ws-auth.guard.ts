import { Injectable, ExecutionContext } from '@nestjs/common';
import { AuthGuard } from '@nestjs/passport';
import { WsException } from '@nestjs/websockets';

@Injectable()
export class WsJwtGuard extends AuthGuard('jwt') {
  getRequest(context: ExecutionContext) {
    // Lấy client socket từ context
    const wsContext = context.switchToWs();
    const client = wsContext.getClient();

    // Tạo một request object giả lập để JWT strategy có thể xử lý
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
    return user;
  }
}
