import { CookieOptions } from 'express';

export const defaultOptionsCookie: Pick<
  CookieOptions,
  'expires' | 'secure' | 'httpOnly' | 'sameSite' | 'path'
> = {
  httpOnly: true,
  secure: process.env.NODE_ENV === 'production',
  sameSite: process.env.NODE_ENV === 'production' ? 'none' : 'lax',
  path: '/',
};
