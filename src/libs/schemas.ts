import { z } from 'zod';

export const requiredString = ({ message }: { message: string }) =>
  z.string().min(1, message);

export const requiredNumber = ({ message }: { message: string }) =>
  z.coerce.number().min(1, message);
