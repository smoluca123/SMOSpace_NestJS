import { registerAs } from '@nestjs/config';

export default registerAs('cache', () => ({
  host: process.env.REDIS_HOST,
  port: parseInt(process.env.REDIS_PORT, 10),
  password: process.env.REDIS_PASSWORD,
  db: parseInt(process.env.REDIS_DB, 10),
  ttl: parseInt(process.env.REDIS_TTL, 10),
}));
