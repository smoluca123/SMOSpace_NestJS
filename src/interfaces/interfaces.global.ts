import { Decimal } from '@prisma/client/runtime/library';
import { Request } from 'express';
import { UserDataType } from 'src/libs/prisma-types';

export interface IResponseType<ResultDataType = null> {
  message: string;
  data: ResultDataType;
  statusCode: number;
  date: Date;
}

export interface IBaseResponseAIType {
  price: string;
  priceNum: number;
  currentCredits: Decimal;
}

export interface IPaginationResponseType<ResultDataType = any> {
  message: string;
  data: {
    items: ResultDataType[];
    totalCount: number;
    totalPage: number;
    currentPage: number;
    pageSize: number;
    hasNextPage: boolean;
    hasPreviousPage: boolean;
  };
  statusCode: number;
  date: Date;
}

export interface IDecodedAccecssTokenType {
  userId: string;
  username: string;
  originalToken: string;
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
  contact: {
    name: string;
    email: string;
    url: string;
  };
}

export interface IRequestWithDecodedAccessToken extends Request {
  decodedAccessToken: IDecodedAccecssTokenType;
}
export interface IRequestWithDecodedAuthToken extends Request {
  user: IDecodedAuthTokenType;
}

export interface IRequestWithFullSession
  extends IRequestWithDecodedAccessToken {
  sessionId: string;
}

export enum RolesLevel {
  USER = 0,
  MANAGER = 1,
  ADMIN = 2,
}

export interface IWithAccessToken {
  accessToken: string;
}

export interface IUserDataWithAccessToken
  extends UserDataType,
    IWithAccessToken {}
