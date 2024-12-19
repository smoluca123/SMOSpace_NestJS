import { z } from 'zod';

export const envSchema = z.object({
  // Server
  SERVER_PORT: z.number().min(1, 'Server port must be a positive integer'),

  // JWT
  JWT_SECRET: z.string().min(1, 'JWT secret is required'),
  JWT_EXPIRES_IN: z.string().min(1, 'JWT expiration time is required'),
  JWT_REFRESH_TOKEN_EXPIRES_IN: z
    .string()
    .min(1, 'JWT refresh token expiration time is required'),

  // Database
  DATABASE_URL: z.string().url('Database URL must be a valid URL'),

  // Supabase
  SUPABASE_URL: z.string().url('Supabase URL must be a valid URL'),
  SUPABASE_KEY: z.string().min(1, 'Supabase key is required'),
  SUPABASE_BUCKET_NAME: z.string().min(1, 'Supabase bucket name is required'),
  SUPABASE_IMAGE_PATH: z
    .string()
    .url('Supabase image path must be a valid URL'),

  // Mail
  MAILER_HOST: z.string().min(1, 'Mailer host is required'),
  MAILER_PORT: z.number().min(1, 'Mailer port must be a positive integer'),
  MAILER_USER: z.string().min(1, 'Mailer username is required'),
  MAILER_PASS: z.string().min(1, 'Mailer password is required'),

  // AI Services
  OPENROUTER_API_KEY: z.string().min(1, 'OpenRouter API key is required'),
  OPENROUTER_PROVIDER_URL: z
    .string()
    .url('OpenRouter provider URL must be a valid URL'),
});

// Export type để sử dụng cho TypeScript
export type EnvConfig = z.infer<typeof envSchema>;
