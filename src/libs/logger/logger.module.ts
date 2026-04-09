import { Global, Module } from '@nestjs/common';
import { LoggerModule as PinoLoggerModule } from 'nestjs-pino';
import configuration from 'src/configs/configuration';
import { AppLoggerService } from './app-logger.service';

const config = configuration();

/**
 * Logger module configuration using nestjs-pino
 * Provides structured logging with request context
 */
@Global()
@Module({
  imports: [
    PinoLoggerModule.forRoot({
      pinoHttp: {
        // Custom log level based on environment
        level: config.NODE_ENV === 'production' ? 'info' : 'debug',

        // Transport configuration for pretty printing in development
        transport:
          config.NODE_ENV !== 'production'
            ? {
                target: 'pino-pretty',
                options: {
                  colorize: true,
                  singleLine: false,
                  translateTime: 'SYS:standard',
                  ignore: 'pid,hostname',
                },
              }
            : undefined,

        // Custom log formatter
        customProps: () => ({
          context: 'HTTP',
        }),

        // Redact sensitive fields from logs
        redact: {
          paths: [
            'req.headers.authorization',
            'req.headers.cookie',
            'res.headers["set-cookie"]',
            'body.password',
            'body.confirmPassword',
            'body.token',
          ],
          remove: true,
        },

        // Custom success message
        customSuccessMessage: (req, res) => {
          return `${req.method} ${req.url} - ${res.statusCode}`;
        },

        // Custom error message
        customErrorMessage: (req, res, err) => {
          return `${req.method} ${req.url} - ${res.statusCode} - ${err.message}`;
        },

        // Custom serializers for request/response
        serializers: {
          req: (req) => ({
            method: req.method,
            url: req.url,
            query: req.query,
            params: req.params,
          }),
          res: (res) => ({
            statusCode: res.statusCode,
          }),
        },

        // Auto logging configuration
        autoLogging: {
          ignore: (req) => {
            // Ignore health check endpoints
            return req.url === '/health' || req.url === '/favicon.ico';
          },
        },
      },
    }),
  ],
  providers: [AppLoggerService],
  exports: [AppLoggerService, PinoLoggerModule],
})
export class LoggerModule {}
