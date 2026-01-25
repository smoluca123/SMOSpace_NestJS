import { Test, TestingModule } from '@nestjs/testing';
import { RateLimiterService } from './rate-limiter.service';
import { RateLimitException } from '../exceptions/rate-limit.exception';
import { RedisModule } from '@liaoliaots/nestjs-redis';
import { ConfigModule, ConfigService } from '@nestjs/config';

describe('RateLimiterService', () => {
  let service: RateLimiterService;

  beforeEach(async () => {
    const module: TestingModule = await Test.createTestingModule({
      imports: [
        ConfigModule.forRoot(),
        RedisModule.forRootAsync({
          imports: [ConfigModule],
          inject: [ConfigService],
          useFactory: (configService: ConfigService) => ({
            config: {
              host: configService.get('REDIS_HOST'),
              port: configService.get('REDIS_PORT'),
              password: configService.get('REDIS_PASSWORD'),
              db: 1, // Use different DB for testing
            },
          }),
        }),
      ],
      providers: [RateLimiterService],
    }).compile();

    service = module.get<RateLimiterService>(RateLimiterService);
  });

  afterEach(async () => {
    // Clean up test keys
    await service.resetLimit('test:key');
  });

  describe('checkLimit', () => {
    it('should allow requests within limit', async () => {
      const result = await service.checkLimit({
        key: 'test:key:1',
        limit: 5,
        window: 60,
      });

      expect(result.allowed).toBe(true);
      expect(result.remaining).toBeLessThanOrEqual(5);
      expect(result.resetAt).toBeGreaterThan(Date.now());
    });

    it('should track multiple requests correctly', async () => {
      const key = 'test:key:2';
      const limit = 5;
      const window = 60;

      // Make 3 requests
      for (let i = 0; i < 3; i++) {
        const result = await service.checkLimit({ key, limit, window });
        expect(result.allowed).toBe(true);
      }

      // Check remaining count
      const result = await service.checkLimit({ key, limit, window });
      expect(result.remaining).toBe(1); // 5 - 4 = 1
    });

    it('should block requests exceeding limit', async () => {
      const key = 'test:key:3';
      const limit = 3;
      const window = 60;

      // Make exactly 3 requests (at limit)
      for (let i = 0; i < 3; i++) {
        const result = await service.checkLimit({ key, limit, window });
        expect(result.allowed).toBe(true);
      }

      // 4th request should be blocked
      const result = await service.checkLimit({ key, limit, window });
      expect(result.allowed).toBe(false);
      expect(result.remaining).toBe(0);
    });
  });

  describe('enforceLimit', () => {
    it('should not throw when within limit', async () => {
      await expect(
        service.enforceLimit({
          key: 'test:key:4',
          limit: 5,
          window: 60,
        }),
      ).resolves.not.toThrow();
    });

    it('should throw RateLimitException when limit exceeded', async () => {
      const key = 'test:key:5';
      const limit = 3;
      const window = 60;

      // Make 3 requests (at limit)
      for (let i = 0; i < 3; i++) {
        await service.enforceLimit({ key, limit, window });
      }

      // 4th request should throw
      await expect(
        service.enforceLimit({ key, limit, window }),
      ).rejects.toThrow(RateLimitException);
    });

    it('should include retryAfter in exception', async () => {
      const key = 'test:key:6';
      const limit = 2;
      const window = 60;

      // Reach limit
      for (let i = 0; i < 2; i++) {
        await service.enforceLimit({ key, limit, window });
      }

      // Try to exceed
      try {
        await service.enforceLimit({ key, limit, window });
        fail('Should have thrown RateLimitException');
      } catch (error) {
        expect(error).toBeInstanceOf(RateLimitException);
        expect(error.getResponse()).toHaveProperty('retryAfter');
        expect(error.getResponse().retryAfter).toBeGreaterThan(0);
      }
    });
  });

  describe('resetLimit', () => {
    it('should reset rate limit for a key', async () => {
      const key = 'test:key:7';
      const limit = 2;
      const window = 60;

      // Reach limit
      for (let i = 0; i < 2; i++) {
        await service.enforceLimit({ key, limit, window });
      }

      // Should be blocked
      await expect(
        service.enforceLimit({ key, limit, window }),
      ).rejects.toThrow(RateLimitException);

      // Reset
      await service.resetLimit(key);

      // Should be allowed again
      await expect(
        service.enforceLimit({ key, limit, window }),
      ).resolves.not.toThrow();
    });
  });

  describe('getRemaining', () => {
    it('should return correct remaining count', async () => {
      const key = 'test:key:8';
      const limit = 5;
      const window = 60;

      // Make 2 requests
      for (let i = 0; i < 2; i++) {
        await service.enforceLimit({ key, limit, window });
      }

      const remaining = await service.getRemaining(key, limit, window);
      expect(remaining).toBe(2); // 5 - 3 = 2
    });
  });

  describe('sliding window behavior', () => {
    it('should allow new requests after window expires', async () => {
      const key = 'test:key:9';
      const limit = 2;
      const window = 2; // 2 seconds

      // Reach limit
      for (let i = 0; i < 2; i++) {
        await service.enforceLimit({ key, limit, window });
      }

      // Should be blocked
      await expect(
        service.enforceLimit({ key, limit, window }),
      ).rejects.toThrow(RateLimitException);

      // Wait for window to expire
      await new Promise((resolve) => setTimeout(resolve, 2100));

      // Should be allowed again
      await expect(
        service.enforceLimit({ key, limit, window }),
      ).resolves.not.toThrow();
    }, 10000); // Increase timeout for this test
  });
});
