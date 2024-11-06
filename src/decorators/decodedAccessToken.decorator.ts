import { createParamDecorator, ExecutionContext } from '@nestjs/common';

import {
  IDecodedAccecssTokenType,
  IRequestWithDecodedAccessToken,
} from 'src/interfaces/interfaces.global';

export const DecodedAccessToken = createParamDecorator(
  (data: string, ctx: ExecutionContext): IDecodedAccecssTokenType => {
    const request = ctx
      .switchToHttp()
      .getRequest() as IRequestWithDecodedAccessToken;
    return request.decodedAccessToken;
  },
);
