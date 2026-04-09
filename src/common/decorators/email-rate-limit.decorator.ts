import { SetMetadata } from '@nestjs/common';

export const RATE_LIMIT_KEY = 'rate_limit';

export interface EmailRateLimitConfig {
  limit?: number; // Number of emails allowed
  window?: number; // Time window in seconds
  keyPrefix?: string; // Custom key prefix
}

/**
 * Decorator to apply rate limiting to email sending methods
 * @param config Rate limit configuration
 * @example @EmailRateLimit({ limit: 5, window: 60 }) // 5 emails per minute
 */
export const EmailRateLimit = (config?: EmailRateLimitConfig) =>
  SetMetadata(RATE_LIMIT_KEY, config);
