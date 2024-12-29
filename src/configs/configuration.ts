import { envSchema } from './../utils/validations';
import * as dotenv from 'dotenv';
dotenv.config();

const configuration = () => ({
  // Server
  SERVER_PORT: parseInt(process.env.SERVER_PORT || '8080', 10),

  // Redis
  REDIS_HOST: process.env.REDIS_HOST,
  REDIS_PORT: parseInt(process.env.REDIS_PORT || '6379', 10),
  REDIS_PASSWORD: process.env.REDIS_PASSWORD,

  // JWT
  JWT_SECRET: process.env.JWT_SECRET,
  JWT_EXPIRES_IN: process.env.JWT_EXPIRES_IN,
  JWT_REFRESH_TOKEN_EXPIRES_IN: process.env.JWT_REFRESH_TOKEN_EXPIRES_IN,

  // Database
  DATABASE_URL: process.env.DATABASE_URL,

  // Supabase
  SUPABASE_URL: process.env.SUPABASE_URL,
  SUPABASE_KEY: process.env.SUPABASE_KEY,
  SUPABASE_BUCKET_NAME: process.env.SUPABASE_BUCKET_NAME,
  SUPABASE_IMAGE_PATH: process.env.SUPABASE_IMAGE_PATH,

  // Mail
  MAILER_HOST: process.env.MAILER_HOST,
  MAILER_PORT: parseInt(process.env.MAILER_PORT || '465', 10),
  MAILER_USER: process.env.MAILER_USER,
  MAILER_PASS: process.env.MAILER_PASS,

  // AI Services
  OPENROUTER_API_KEY: process.env.OPENROUTER_API_KEY,
  OPENROUTER_PROVIDER_URL: process.env.OPENROUTER_PROVIDER_URL,
});

const validConfig = envSchema.safeParse(configuration());

if (validConfig.error) {
  throw new Error(validConfig.error.message);
}

const { data: configData } = validConfig;
export { configData };

export default configuration;
