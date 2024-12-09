import { z } from 'zod';

// const requiredString = z.string().min(1, 'Value must be a non-empty string');

export const envSchema = z.object({
  SERVER_PORT: z.number().min(1, 'Server port must be a positive integer'),
});
