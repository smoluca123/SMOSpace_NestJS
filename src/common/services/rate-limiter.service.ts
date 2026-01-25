import { Injectable } from '@nestjs/common';
import { RedisService } from '@liaoliaots/nestjs-redis';
import type Redis from 'ioredis';
import { RateLimitException } from '../exceptions/rate-limit.exception';

export interface RateLimitOptions {
  key: string; // Redis key identifier
  limit: number; // Maximum number of requests
  window: number; // Time window in seconds
}

export interface RateLimitResult {
  allowed: boolean;
  remaining: number;
  resetAt: number; // Timestamp when the limit will reset
}

@Injectable()
export class RateLimiterService {
  private readonly redis: Redis;

  constructor(private readonly redisService: RedisService) {
    // Get the default Redis client
    this.redis = this.redisService.getOrThrow();
  }

  /**
   * Check if an action is allowed based on rate limit
   * Uses sliding window algorithm for accurate rate limiting
   */
  async checkLimit(options: RateLimitOptions): Promise<RateLimitResult> {
    const { key, limit, window } = options;
    const now = Date.now();
    const windowMs = window * 1000;
    const redisKey = `rate_limit:${key}`;

    // Step 1: Remove old entries outside the time window
    await this.redis.zremrangebyscore(redisKey, 0, now - windowMs);

    // Step 2: Get current count of requests in the window
    const count = await this.redis.zcard(redisKey);

    // Step 3: Check if request is allowed
    const allowed = count < limit;

    // Step 4: Only add entry if allowed (prevents infinite blocking)
    if (allowed) {
      const pipeline = this.redis.pipeline();
      pipeline.zadd(redisKey, now, `${now}`);
      pipeline.expire(redisKey, window + 1);
      await pipeline.exec();
    }

    // Step 5: Calculate resetAt from OLDEST entry in window
    let resetAt = now + windowMs;

    if (count > 0) {
      // Get the oldest entry timestamp
      const oldestEntries = await this.redis.zrange(
        redisKey,
        0,
        0,
        'WITHSCORES',
      );
      if (oldestEntries && oldestEntries.length >= 2) {
        const oldestTimestamp = parseInt(oldestEntries[1]);
        resetAt = oldestTimestamp + windowMs;
      }
    }

    const remaining = Math.max(0, limit - count - (allowed ? 1 : 0));

    return {
      allowed,
      remaining,
      resetAt,
    };
  }

  /**
   * Enforce rate limit and throw exception if exceeded
   */
  async enforceLimit(options: RateLimitOptions): Promise<void> {
    const result = await this.checkLimit(options);
    console.log(result);
    if (!result.allowed) {
      const retryAfter = Math.ceil((result.resetAt - Date.now()) / 1000);
      throw new RateLimitException(
        retryAfter,
        `Too many requests. Please try again in ${retryAfter} seconds`,
      );
    }
  }

  /**
   * Get remaining requests for a key
   */
  async getRemaining(
    key: string,
    limit: number,
    window: number,
  ): Promise<number> {
    const result = await this.checkLimit({ key, limit, window });
    return result.remaining;
  }

  /**
   * Reset rate limit for a specific key
   */
  async resetLimit(key: string): Promise<void> {
    const redisKey = `rate_limit:${key}`;
    await this.redis.del(redisKey);
  }
}
