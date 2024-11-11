import { applyDecorators } from '@nestjs/common';
import { ApiQuery } from '@nestjs/swagger';

export function ApiQueryLimitAndPage(options?: {
  limit?: {
    name?: string;
    defaultValue?: number;
  };

  page?: {
    name?: string;
    defaultValue?: number;
  };
}) {
  return applyDecorators(
    ApiQuery({
      name: options?.limit?.name || 'limit',
      description: `Limit result on page (Default : ${options?.limit?.defaultValue || 10})`,
      required: false,
    }),
    ApiQuery({
      name: options?.page?.name || 'page',
      description: `Limit result on page (Default : ${options?.page?.defaultValue || 1})`,
      required: false,
    }),
  );
}
