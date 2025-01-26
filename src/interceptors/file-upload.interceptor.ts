import {
  Injectable,
  NestInterceptor,
  ExecutionContext,
  CallHandler,
  BadRequestException,
} from '@nestjs/common';
import { Observable } from 'rxjs';
import { FileValidationOptions } from 'src/interfaces/file-validation.interface';

@Injectable()
export class FileUploadInterceptor implements NestInterceptor {
  constructor(private options: FileValidationOptions) {}

  intercept(context: ExecutionContext, next: CallHandler): Observable<any> {
    const request = context.switchToHttp().getRequest();
    const file = request.file;

    if (!file) {
      throw new BadRequestException('File is required');
    }

    // Validate file type
    if (
      this.options.allowedMimeTypes &&
      !this.options.allowedMimeTypes.includes(file.mimetype)
    ) {
      throw new BadRequestException(
        `File type not allowed. Allowed types: ${this.options.allowedMimeTypes.join(', ')}`,
      );
    }

    // Validate file size
    if (this.options.maxSize && file.size > this.options.maxSize) {
      throw new BadRequestException(
        `File too large. Max size: ${this.options.maxSize / (1024 * 1024)}MB`,
      );
    }

    return next.handle();
  }
}
