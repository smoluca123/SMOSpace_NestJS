import { Injectable } from '@nestjs/common';
import { JwtService, JwtSignOptions } from '@nestjs/jwt';
import { handleDefaultError } from 'src/global/functions.global';
import { ConfigService } from '@nestjs/config';

@Injectable()
export class JwtServiceCustom {
  constructor(
    private readonly jwt: JwtService,
    private readonly config: ConfigService,
  ) {}

  async generateAccessToken(
    payload: { userId: string; username: string; key?: string },
    options?: JwtSignOptions & { isRefreshToken?: boolean },
  ): Promise<string> {
    try {
      let optionsFilled = null;
      if (options) {
        // eslint-disable-next-line @typescript-eslint/no-unused-vars, prefer-const
        let { isRefreshToken, ...newOptions } = options;
        if (options?.isRefreshToken) {
          optionsFilled = {
            ...newOptions,
            expiresIn: this.config.get('JWT_REFRESH_TOKEN_EXPIRES_IN'),
          };
        } else {
          optionsFilled = options;
        }
      }
      return await this.generateJwt(payload, optionsFilled || null);
    } catch (error) {
      handleDefaultError(error);
    }
  }
  async generateJwt(payload: any, options?: JwtSignOptions): Promise<string> {
    try {
      return await this.jwt.signAsync(payload, options);
    } catch (error) {
      handleDefaultError(error);
    }
  }
}
