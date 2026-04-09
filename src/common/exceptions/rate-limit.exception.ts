import { HttpException, HttpStatus } from '@nestjs/common';

export class RateLimitException extends HttpException {
  constructor(retryAfter: number, message?: string) {
    super(
      {
        statusCode: HttpStatus.TOO_MANY_REQUESTS,
        message: message || 'Too many requests. Please try again later.',
        retryAfter,
      },
      HttpStatus.TOO_MANY_REQUESTS,
    );
  }
}
