import { PipeTransform, Injectable } from '@nestjs/common';
import { Schema } from 'zod';

@Injectable()
export class ZodValidationPipe implements PipeTransform {
  constructor(private schema: Schema) {}

  transform(value: any) {
    // Skip validation if value is a Socket instance
    if (value?.handshake) {
      return value;
    }
    const data = this.schema.parse(value);
    return data;
  }
}
