// ip.decorator.ts
import { createParamDecorator, ExecutionContext } from '@nestjs/common';

export const IpAddress = createParamDecorator(
  (data: unknown, ctx: ExecutionContext) => {
    const request = ctx.switchToHttp().getRequest();

    let ip =
      request.headers['x-forwarded-for']?.split(',')[0] ||
      request.headers['x-real-ip'] ||
      request.headers['origin'] ||
      request.connection.remoteAddress ||
      request.socket.remoteAddress ||
      request.ip;

    // Xử lý bỏ http://, https:// và port
    ip = ip
      ?.replace(/^https?:\/\//, '') // Bỏ http:// hoặc https://
      .replace(/:\d+$/, '') // Bỏ port number
      .replace(/\/+$/, ''); // Bỏ dấu / ở cuối nếu có

    // Xử lý địa chỉ IPv6 localhost
    if (ip === '::1' || ip === '::ffff:127.0.0.1') {
      return '127.0.0.1';
    }

    // Xử lý địa chỉ IPv6 thành IPv4
    if (ip?.startsWith('::ffff:')) {
      return ip.substring(7);
    }

    return ip;
  },
);
