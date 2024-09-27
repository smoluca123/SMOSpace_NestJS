import { Request } from 'express';

export interface IResponseType<ResultDataType = any> {
  message: string;
  data: ResultDataType;
  statusCode: number;
  date: Date;
}

export interface IDecodedAccecssTokenType {
  userId: string;
  username: string;
  key: string | number;
  iat?: string | number;
  exp?: string | number;
}

export interface IDecodedAuthTokenType {
  id: string;
  auth_code: string;
  iat?: string | number;
  exp?: string | number;
}

export interface IInfoApiType {
  name: string;
  author: string;
  version: string;
  description: string;
  authorizationToken?: string;
  swagger: string;
}

export interface IRequestWithDecodedAccessToken extends Request {
  decodedAccessToken: IDecodedAccecssTokenType;
}
export interface IRequestWithDecodedAuthToken extends Request {
  user: IDecodedAuthTokenType;
}

export enum RolesLevel {
  USER = 0,
  MANAGER = 1,
  ADMIN = 2,
}
