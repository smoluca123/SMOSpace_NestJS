import { Injectable } from '@nestjs/common';
import { PinoLogger, InjectPinoLogger } from 'nestjs-pino';

/**
 * Custom Logger Service wrapping PinoLogger
 * Use this service in your modules for structured logging with context
 *
 * @example
 * // In a service
 * constructor(private readonly logger: AppLoggerService) {
 *   this.logger.setContext('MyService');
 * }
 *
 * // Usage
 * this.logger.log('User created', { userId: '123' });
 * this.logger.error('Failed to create user', error, { email: 'test@example.com' });
 */
@Injectable()
export class AppLoggerService {
  private context: string = 'Application';

  constructor(
    @InjectPinoLogger(AppLoggerService.name)
    private readonly logger: PinoLogger,
  ) {}

  /**
   * Set the context for this logger instance
   */
  setContext(context: string): void {
    this.context = context;
    this.logger.setContext(context);
  }

  /**
   * Log a message at info level
   */
  log(message: string, data?: Record<string, unknown>): void {
    if (data) {
      this.logger.info(data, message);
    } else {
      this.logger.info(message);
    }
  }

  /**
   * Log a message at debug level
   */
  debug(message: string, data?: Record<string, unknown>): void {
    if (data) {
      this.logger.debug(data, message);
    } else {
      this.logger.debug(message);
    }
  }

  /**
   * Log a message at warn level
   */
  warn(message: string, data?: Record<string, unknown>): void {
    if (data) {
      this.logger.warn(data, message);
    } else {
      this.logger.warn(message);
    }
  }

  /**
   * Log an error
   */
  error(message: string, error?: Error, data?: Record<string, unknown>): void {
    const errorData = {
      ...data,
      ...(error && {
        errorName: error.name,
        errorMessage: error.message,
        stack: error.stack,
      }),
    };

    if (Object.keys(errorData).length > 0) {
      this.logger.error(errorData, message);
    } else {
      this.logger.error(message);
    }
  }

  /**
   * Log a message at fatal level
   */
  fatal(message: string, error?: Error, data?: Record<string, unknown>): void {
    const errorData = {
      ...data,
      ...(error && {
        errorName: error.name,
        errorMessage: error.message,
        stack: error.stack,
      }),
    };

    if (Object.keys(errorData).length > 0) {
      this.logger.fatal(errorData, message);
    } else {
      this.logger.fatal(message);
    }
  }

  /**
   * Log a message at trace level
   */
  trace(message: string, data?: Record<string, unknown>): void {
    if (data) {
      this.logger.trace(data, message);
    } else {
      this.logger.trace(message);
    }
  }
}
