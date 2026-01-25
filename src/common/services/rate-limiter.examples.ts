/**
 * EXAMPLES: How to use Rate Limiter in different scenarios
 */

import { Injectable } from '@nestjs/common';
import { RateLimiterService } from 'src/common/services/rate-limiter.service';
import {
  EMAIL_RATE_LIMITS,
  RATE_LIMIT_KEY_PREFIXES,
} from 'src/common/constants/rate-limits.constants';

// ============================================================================
// EXAMPLE 1: Basic Email Rate Limiting
// ============================================================================

@Injectable()
export class EmailServiceExample {
  constructor(private readonly rateLimiter: RateLimiterService) {}

  async sendActivationEmail(email: string) {
    // Apply rate limiting per recipient email
    await this.rateLimiter.enforceLimit({
      key: `${RATE_LIMIT_KEY_PREFIXES.EMAIL_ACTIVATION}:${email}`,
      limit: EMAIL_RATE_LIMITS.ACTIVATION.limit,
      window: EMAIL_RATE_LIMITS.ACTIVATION.window,
    });

    // Send email logic here...
    console.log(`Activation email sent to ${email}`);
  }
}

// ============================================================================
// EXAMPLE 2: Check Rate Limit Before Action
// ============================================================================

@Injectable()
export class EmailServiceWithCheckExample {
  constructor(private readonly rateLimiter: RateLimiterService) {}

  async sendEmailWithCheck(email: string) {
    // Check rate limit without throwing exception
    const result = await this.rateLimiter.checkLimit({
      key: `email:general:${email}`,
      limit: 20,
      window: 60,
    });

    if (!result.allowed) {
      const retryAfterSeconds = Math.ceil((result.resetAt - Date.now()) / 1000);
      return {
        success: false,
        message: `Rate limit exceeded. Please try again in ${retryAfterSeconds} seconds`,
        retryAfter: retryAfterSeconds,
      };
    }

    // Send email...
    return {
      success: true,
      remaining: result.remaining,
      message: 'Email sent successfully',
    };
  }
}

// ============================================================================
// EXAMPLE 3: API Rate Limiting per User
// ============================================================================

@Injectable()
export class ApiRateLimitExample {
  constructor(private readonly rateLimiter: RateLimiterService) {}

  async handleApiRequest(userId: string, endpoint: string) {
    // Rate limit per user per endpoint
    await this.rateLimiter.enforceLimit({
      key: `api:${endpoint}:user:${userId}`,
      limit: 100, // 100 requests
      window: 60, // per minute
    });

    // Process API request...
    return { message: 'API request processed' };
  }
}

// ============================================================================
// EXAMPLE 4: IP-based Rate Limiting (for anonymous users)
// ============================================================================

@Injectable()
export class PublicApiRateLimitExample {
  constructor(private readonly rateLimiter: RateLimiterService) {}

  async handlePublicRequest(ipAddress: string) {
    // Rate limit by IP address
    await this.rateLimiter.enforceLimit({
      key: `api:public:ip:${ipAddress}`,
      limit: 50, // 50 requests
      window: 300, // per 5 minutes
    });

    // Process request...
    return { message: 'Public API request processed' };
  }
}

// ============================================================================
// EXAMPLE 5: Tiered Rate Limiting (based on user subscription)
// ============================================================================

@Injectable()
export class TieredRateLimitExample {
  constructor(private readonly rateLimiter: RateLimiterService) {}

  async sendEmail(userId: string, userTier: 'free' | 'premium' | 'enterprise') {
    // Different limits based on user tier
    const limits = {
      free: { limit: 10, window: 60 },
      premium: { limit: 50, window: 60 },
      enterprise: { limit: 200, window: 60 },
    };

    const { limit, window } = limits[userTier];

    await this.rateLimiter.enforceLimit({
      key: `email:user:${userId}`,
      limit,
      window,
    });

    // Send email...
    return { message: `Email sent (${userTier} tier)` };
  }
}

// ============================================================================
// EXAMPLE 6: Combined Rate Limiting (email + IP)
// ============================================================================

@Injectable()
export class CombinedRateLimitExample {
  constructor(private readonly rateLimiter: RateLimiterService) {}

  async sendEmail(email: string, ipAddress: string) {
    // Check both email and IP address
    await Promise.all([
      // Rate limit by email
      this.rateLimiter.enforceLimit({
        key: `email:activation:${email}`,
        limit: 10,
        window: 60,
      }),
      // Rate limit by IP
      this.rateLimiter.enforceLimit({
        key: `email:activation:ip:${ipAddress}`,
        limit: 50, // Allow more requests per IP (multiple users)
        window: 60,
      }),
    ]);

    // Send email...
    return { message: 'Email sent with combined rate limiting' };
  }
}

// ============================================================================
// EXAMPLE 7: Admin Reset Rate Limit
// ============================================================================

@Injectable()
export class AdminRateLimitExample {
  constructor(private readonly rateLimiter: RateLimiterService) {}

  async resetUserRateLimit(email: string) {
    // Admin can reset rate limit for a specific user
    await this.rateLimiter.resetLimit(`email:activation:${email}`);

    return {
      message: `Rate limit reset for ${email}`,
    };
  }
}

// ============================================================================
// EXAMPLE 8: Get Remaining Requests
// ============================================================================

@Injectable()
export class RateLimitInfoExample {
  constructor(private readonly rateLimiter: RateLimiterService) {}

  async getRateLimitInfo(userId: string) {
    const limit = 100;
    const window = 60;
    const key = `api:user:${userId}`;

    // Get remaining requests without making a request
    const remaining = await this.rateLimiter.getRemaining(key, limit, window);

    return {
      limit,
      remaining,
      window,
      message: `You have ${remaining} requests remaining`,
    };
  }
}

// ============================================================================
// EXAMPLE 9: Custom Error Handling
// ============================================================================

@Injectable()
export class CustomErrorHandlingExample {
  constructor(private readonly rateLimiter: RateLimiterService) {}

  async sendEmailWithCustomError(email: string) {
    try {
      await this.rateLimiter.enforceLimit({
        key: `email:activation:${email}`,
        limit: 10,
        window: 60,
      });

      // Send email...
      return { success: true };
    } catch (error) {
      if (error.status === 429) {
        // Rate limit exceeded
        const retryAfter = error.getResponse().retryAfter;

        return {
          success: false,
          error: 'RATE_LIMIT_EXCEEDED',
          message: `Too many emails sent. Please wait ${retryAfter} seconds`,
          retryAfter,
        };
      }

      throw error;
    }
  }
}

// ============================================================================
// EXAMPLE 10: Batch Operations with Rate Limiting
// ============================================================================

@Injectable()
export class BatchRateLimitExample {
  constructor(private readonly rateLimiter: RateLimiterService) {}

  async sendBulkEmails(emails: string[]) {
    const results = [];

    for (const email of emails) {
      try {
        // Check rate limit for each email
        const result = await this.rateLimiter.checkLimit({
          key: `email:bulk:${email}`,
          limit: 5,
          window: 300, // 5 minutes
        });

        if (result.allowed) {
          // Send email
          results.push({
            email,
            status: 'sent',
            remaining: result.remaining,
          });
        } else {
          // Skip if rate limited
          const retryAfter = Math.ceil((result.resetAt - Date.now()) / 1000);
          results.push({
            email,
            status: 'rate_limited',
            retryAfter,
          });
        }
      } catch (error) {
        results.push({
          email,
          status: 'error',
          error: error.message,
        });
      }
    }

    return {
      total: emails.length,
      sent: results.filter((r) => r.status === 'sent').length,
      rateLimited: results.filter((r) => r.status === 'rate_limited').length,
      errors: results.filter((r) => r.status === 'error').length,
      details: results,
    };
  }
}

// ============================================================================
// EXAMPLE 11: Time-based Rate Limiting (different limits at different times)
// ============================================================================

@Injectable()
export class TimeBasedRateLimitExample {
  constructor(private readonly rateLimiter: RateLimiterService) {}

  async sendEmail(email: string) {
    const hour = new Date().getHours();

    // Stricter limits during peak hours (9 AM - 5 PM)
    const isPeakHour = hour >= 9 && hour < 17;
    const limit = isPeakHour ? 5 : 20;
    const window = 60;

    await this.rateLimiter.enforceLimit({
      key: `email:time-based:${email}`,
      limit,
      window,
    });

    return {
      message: `Email sent (${isPeakHour ? 'peak' : 'off-peak'} hours)`,
    };
  }
}

// ============================================================================
// EXAMPLE 12: Progressive Rate Limiting
// ============================================================================

@Injectable()
export class ProgressiveRateLimitExample {
  constructor(private readonly rateLimiter: RateLimiterService) {}

  async sendEmail(email: string, attemptCount: number) {
    // Reduce limit as attempts increase
    const baseLimit = 10;
    const limit = Math.max(1, baseLimit - attemptCount);

    await this.rateLimiter.enforceLimit({
      key: `email:progressive:${email}`,
      limit,
      window: 60,
    });

    return {
      message: `Email sent (attempt ${attemptCount})`,
      currentLimit: limit,
    };
  }
}
