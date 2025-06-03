import {
  Injectable,
  NestInterceptor,
  ExecutionContext,
  CallHandler,
} from '@nestjs/common';
import { Observable } from 'rxjs';
import { map } from 'rxjs/operators';
import {
  IResponseType,
  IPaginationResponseType,
} from 'src/interfaces/interfaces.global';

@Injectable()
export class ResponseInterceptor implements NestInterceptor {
  intercept(context: ExecutionContext, next: CallHandler): Observable<any> {
    return next.handle().pipe(
      map((data) => {
        // If data is already formatted as IResponseType or IPaginationResponseType, return as is
        if (this.isFormattedResponse(data)) {
          return data;
        }

        // If data is an array with pagination metadata, format as paginated response
        if (this.isPaginatedData(data)) {
          return this.formatPaginatedResponse(data);
        }

        // Format as standard response
        return this.formatResponse(data);
      }),
    );
  }

  private isFormattedResponse(data: any): boolean {
    return (
      data &&
      typeof data === 'object' &&
      'message' in data &&
      'data' in data &&
      'statusCode' in data &&
      'date' in data
    );
  }

  private isPaginatedData(data: any): boolean {
    return (
      data.type === 'pagination' ||
      (data &&
        data.data &&
        typeof data === 'object' &&
        'items' in data.data &&
        'totalCount' in data.data &&
        'currentPage' in data.data &&
        'pageSize' in data.data)
    );
  }

  private formatResponse<T>({
    data,
    message,
    statusCode,
  }: {
    data: T;
    message?: string;
    statusCode?: number;
  }): IResponseType<T> {
    return {
      message: message || 'Success',
      data,
      statusCode: statusCode || 200,
      date: new Date(),
    };
  }

  private formatPaginatedResponse<T>({
    data,
    message,
    statusCode,
  }: {
    data: {
      items: T[];
      totalCount: number;
      currentPage: number;
      pageSize: number;
    };
    message?: string;
    statusCode?: number;
  }): IPaginationResponseType<T> {
    const { items, totalCount, currentPage, pageSize } = data;
    const totalPage = Math.ceil(totalCount / pageSize);
    const hasNextPage = currentPage < totalPage;
    const hasPreviousPage = currentPage > 1;

    return {
      message: message || 'Success',
      data: {
        totalCount,
        totalPage,
        currentPage,
        pageSize,
        hasNextPage,
        hasPreviousPage,
        items,
      },
      statusCode: statusCode || 200,
      date: new Date(),
    };
  }
}
