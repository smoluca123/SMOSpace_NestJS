# Email Rate Limiting với Redis

## Tổng quan

Hệ thống rate limiting cho email sử dụng Redis để giới hạn số lượng email được gửi trong một khoảng thời gian nhất định. Điều này giúp:

- **Ngăn chặn spam**: Giới hạn số lượng email gửi đến cùng một địa chỉ
- **Bảo vệ hệ thống**: Tránh tình trạng gửi email quá tải
- **Tuân thủ quy định**: Đáp ứng các giới hạn của nhà cung cấp email
- **Bảo mật**: Ngăn chặn các cuộc tấn công email bombing

## Kiến trúc

### Sliding Window Algorithm

Rate limiter sử dụng **Sliding Window Algorithm** với Redis Sorted Sets:

- Mỗi request được lưu với timestamp trong Sorted Set
- Loại bỏ các requests cũ ngoài time window
- Đếm số lượng requests còn lại để quyết định cho phép hay từ chối

### Components

```
📦 Common
 ┣ 📂 exceptions
 ┃ ┗ 📜 rate-limit.exception.ts     # Custom exception cho rate limiting
 ┣ 📂 services
 ┃ ┣ 📜 rate-limiter.service.ts     # Core rate limiter service
 ┃ ┗ 📜 rate-limiter.module.ts      # Global module
 ┣ 📂 decorators
 ┃ ┗ 📜 email-rate-limit.decorator.ts  # Decorator (optional)
 ┗ 📂 constants
   ┗ 📜 rate-limits.constants.ts    # Rate limit configurations
```

## Cấu hình

### Rate Limits (constants/rate-limits.constants.ts)

```typescript
export const EMAIL_RATE_LIMITS = {
  // Email kích hoạt tài khoản: 10 emails/phút
  ACTIVATION: {
    limit: 10,
    window: 60,
  },

  // Email quên mật khẩu: 5 emails/5 phút (nghiêm ngặt hơn)
  FORGOT_PASSWORD: {
    limit: 5,
    window: 300,
  },

  // Email chung: 20 emails/phút
  GENERAL: {
    limit: 20,
    window: 60,
  },
};
```

### Key Prefixes

```typescript
export const RATE_LIMIT_KEY_PREFIXES = {
  EMAIL_ACTIVATION: 'email:activation',
  EMAIL_FORGOT_PASSWORD: 'email:forgot-password',
  EMAIL_GENERAL: 'email:general',
  EMAIL_NOTIFICATION: 'email:notification',
};
```

## Sử dụng

### 1. Trong Service

```typescript
import { Injectable } from '@nestjs/common';
import { RateLimiterService } from 'src/common/services/rate-limiter.service';
import {
  EMAIL_RATE_LIMITS,
  RATE_LIMIT_KEY_PREFIXES,
} from 'src/common/constants/rate-limits.constants';

@Injectable()
export class EmailService {
  constructor(private readonly rateLimiter: RateLimiterService) {}

  async sendEmail(email: string) {
    // Apply rate limiting
    await this.rateLimiter.enforceLimit({
      key: `${RATE_LIMIT_KEY_PREFIXES.EMAIL_ACTIVATION}:${email}`,
      limit: EMAIL_RATE_LIMITS.ACTIVATION.limit,
      window: EMAIL_RATE_LIMITS.ACTIVATION.window,
    });

    // Send email...
  }
}
```

### 2. Check Rate Limit Trước Khi Thực Hiện

```typescript
// Check without throwing exception
const result = await this.rateLimiter.checkLimit({
  key: `email:activation:${email}`,
  limit: 10,
  window: 60,
});

if (!result.allowed) {
  // Handle rate limit exceeded
  console.log(`Rate limit exceeded. Retry after ${result.resetAt}`);
  return;
}

// Proceed with sending email
```

### 3. Reset Rate Limit (Admin)

```typescript
// Reset rate limit for a specific key
await this.rateLimiter.resetLimit(`email:activation:user@example.com`);
```

### 4. Lấy Số Lần Còn Lại

```typescript
const remaining = await this.rateLimiter.getRemaining(
  `email:activation:user@example.com`,
  10,
  60,
);

console.log(`Remaining requests: ${remaining}`);
```

## API Response

### Exception Response (429 Too Many Requests)

Khi rate limit bị vượt quá, API sẽ trả về:

```json
{
  "statusCode": 429,
  "message": "Too many requests. Please try again later.",
  "retryAfter": 45
}
```

- `statusCode`: HTTP 429
- `message`: Thông báo lỗi
- `retryAfter`: Số giây cần đợi trước khi thử lại

### Frontend Handling

```typescript
try {
  await sendActivationEmail(email);
} catch (error) {
  if (error.response?.status === 429) {
    const retryAfter = error.response.data.retryAfter;
    alert(`Vui lòng đợi ${retryAfter} giây trước khi thử lại`);
  }
}
```

## Redis Keys Structure

Rate limiter sử dụng Redis Sorted Sets với cấu trúc key:

```
rate_limit:{type}:{identifier}
```

Ví dụ:

```
rate_limit:email:activation:user@example.com
rate_limit:email:forgot-password:admin@example.com
```

### TTL (Time To Live)

Mỗi key tự động expire sau `window + 1` giây để tránh memory leak.

## Performance

### Atomic Operations

Sử dụng Redis Pipeline để đảm bảo các thao tác là atomic:

```typescript
const pipeline = this.redis.pipeline();
pipeline.zremrangebyscore(redisKey, 0, now - windowMs);
pipeline.zcard(redisKey);
pipeline.zadd(redisKey, now, `${now}`);
pipeline.expire(redisKey, window + 1);
await pipeline.exec();
```

### Complexity

- **Time**: O(log N) cho mỗi request (do ZADD và ZREMRANGEBYSCORE)
- **Space**: O(N) với N là số requests trong window

## Testing

### Manual Testing với Redis CLI

```bash
# Xem tất cả rate limit keys
redis-cli KEYS "rate_limit:*"

# Xem chi tiết một key
redis-cli ZRANGE "rate_limit:email:activation:test@example.com" 0 -1 WITHSCORES

# Xóa một key (reset rate limit)
redis-cli DEL "rate_limit:email:activation:test@example.com"

# Đếm số requests hiện tại
redis-cli ZCARD "rate_limit:email:activation:test@example.com"
```

### Unit Testing

```typescript
describe('RateLimiterService', () => {
  it('should allow requests within limit', async () => {
    const result = await rateLimiter.checkLimit({
      key: 'test:key',
      limit: 5,
      window: 60,
    });

    expect(result.allowed).toBe(true);
    expect(result.remaining).toBeLessThanOrEqual(5);
  });

  it('should block requests exceeding limit', async () => {
    // Send 5 requests (limit)
    for (let i = 0; i < 5; i++) {
      await rateLimiter.enforceLimit({
        key: 'test:key',
        limit: 5,
        window: 60,
      });
    }

    // 6th request should fail
    await expect(
      rateLimiter.enforceLimit({
        key: 'test:key',
        limit: 5,
        window: 60,
      }),
    ).rejects.toThrow(RateLimitException);
  });
});
```

## Tuning và Best Practices

### 1. Chọn Window Size Phù Hợp

- **Quá nhỏ** (< 10s): User có thể bị block quá nhanh
- **Quá lớn** (> 1 hour): Không hiệu quả trong việc ngăn chặn abuse
- **Khuyến nghị**: 60-300 giây cho hầu hết các trường hợp

### 2. Limit Numbers

```typescript
// Email nhạy cảm (forgot password, 2FA)
limit: 3-5 emails per 5-10 minutes

// Email thông thường (activation)
limit: 10-20 emails per minute

// Email notification
limit: 50-100 emails per minute
```

### 3. Key Design

Sử dụng các identifier khác nhau tùy use case:

```typescript
// Per user email
`email:activation:${email}`// Per user ID (nếu đã login)
`email:notification:user:${userId}`// Per IP (cho anonymous users)
`email:contact:ip:${ipAddress}`// Kết hợp nhiều yếu tố
`email:activation:${email}:${ipAddress}`;
```

### 4. Monitoring

Theo dõi các metrics:

- Số lần rate limit bị hit
- Phân bố requests theo time
- Top users bị rate limited
- Redis memory usage cho rate limiting keys

## Mở rộng

### 1. Thêm Rate Limit Cho API Endpoint

```typescript
@Injectable()
export class ApiRateLimitGuard implements CanActivate {
  constructor(private rateLimiter: RateLimiterService) {}

  async canActivate(context: ExecutionContext): Promise<boolean> {
    const request = context.switchToHttp().getRequest();
    const userId = request.user?.id || request.ip;

    await this.rateLimiter.enforceLimit({
      key: `api:${request.path}:${userId}`,
      limit: 100,
      window: 60,
    });

    return true;
  }
}
```

### 2. Custom Decorator

```typescript
@EmailRateLimit({ limit: 5, window: 300 })
async sendForgotPasswordEmail() {
  // ...
}
```

### 3. Dynamic Rate Limits

```typescript
// Dựa trên user tier
const limit = user.isPremium ? 100 : 10;

await this.rateLimiter.enforceLimit({
  key: `email:${email}`,
  limit,
  window: 60,
});
```

## Troubleshooting

### Issue: Rate limit không hoạt động

**Giải pháp:**

1. Kiểm tra Redis connection
2. Verify RateLimiterModule được import vào AppModule
3. Kiểm tra key format có đúng không

### Issue: Users bị block quá nhanh

**Giải pháp:**

- Tăng `limit` hoặc `window`
- Sử dụng sliding window thay vì fixed window
- Implement tiered rate limiting

### Issue: Redis memory tăng cao

**Giải pháp:**

- Đảm bảo TTL được set đúng
- Dọn dẹp old keys định kỳ
- Sử dụng Redis eviction policy phù hợp

## Changelog

- **v1.0.0**: Initial implementation với sliding window algorithm
- Rate limiting cho activation và forgot password emails
- Global RateLimiterModule
- Constants-based configuration
