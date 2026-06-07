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

    // Strip http://, https:// and the port
    ip = ip
      ?.replace(/^https?:\/\//, '') // Remove http:// or https://
      .replace(/:\d+$/, '') // Remove the port number
      .replace(/\/+$/, ''); // Remove a trailing slash if present

    // Handle IPv6 localhost
    if (ip === '::1' || ip === '::ffff:127.0.0.1') {
      return '127.0.0.1';
    }

    // Convert IPv6-mapped address to IPv4
    if (ip?.startsWith('::ffff:')) {
      return ip.substring(7);
    }

    return ip;
  },
);
