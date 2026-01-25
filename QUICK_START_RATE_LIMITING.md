# 🚀 Quick Start: Email Rate Limiting

## Tóm tắt

Hệ thống rate limiting đã được tích hợp sẵn vào EmailService. Tất cả emails sẽ tự động được kiểm tra rate limit trước khi gửi.

## ✅ Đã Hoạt Động Tự Động

### Email Kích Hoạt Tài Khoản

- **Giới hạn**: 10 emails / phút / địa chỉ email
- **Method**: `sendActiveAccountEmail()`

### Email Quên Mật Khẩu

- **Giới hạn**: 5 emails / 5 phút / địa chỉ email
- **Method**: `sendForgotPasswordEmail()`

## 📝 Không Cần Làm Gì Thêm!

Code hiện tại của bạn:

```typescript
await this.emailService.sendActiveAccountEmail({
  email: 'user@example.com',
  context: {
    name: 'John Doe',
    verification_code: '123456',
  },
});
```

**Sẽ tự động:**

- ✅ Kiểm tra rate limit
- ✅ Throw HTTP 429 nếu vượt quá
- ✅ Gửi email nếu OK

## 🔴 Response Khi Vượt Rate Limit

```json
{
  "statusCode": 429,
  "message": "Too many requests. Please try again later.",
  "retryAfter": 45
}
```

## 🎨 Frontend Handling

```typescript
try {
  await api.sendActivationEmail(email);
  toast.success('Email sent!');
} catch (error) {
  if (error.response?.status === 429) {
    const retryAfter = error.response.data.retryAfter;
    toast.error(`Vui lòng đợi ${retryAfter} giây trước khi thử lại`);
  }
}
```

## ⚙️ Thay Đổi Giới Hạn

### File: `src/common/constants/rate-limits.constants.ts`

```typescript
export const EMAIL_RATE_LIMITS = {
  ACTIVATION: {
    limit: 10, // ← Thay đổi số lượng
    window: 60, // ← Thay đổi thời gian (giây)
  },
  FORGOT_PASSWORD: {
    limit: 5, // ← Thay đổi số lượng
    window: 300, // ← Thay đổi thời gian (giây)
  },
};
```

## 🔧 Thêm Rate Limit Cho Email Mới

### 1. Thêm vào constants:

```typescript
// src/common/constants/rate-limits.constants.ts
export const EMAIL_RATE_LIMITS = {
  // ... existing
  NEWSLETTER: {
    // ← Thêm mới
    limit: 50,
    window: 60,
  },
};

export const RATE_LIMIT_KEY_PREFIXES = {
  // ... existing
  EMAIL_NEWSLETTER: 'email:newsletter', // ← Thêm mới
};
```

### 2. Áp dụng trong service:

```typescript
// src/resources/email/email.service.ts
async sendNewsletterEmail(email: string) {
  // Apply rate limiting
  await this.rateLimiter.enforceLimit({
    key: `${RATE_LIMIT_KEY_PREFIXES.EMAIL_NEWSLETTER}:${email}`,
    limit: EMAIL_RATE_LIMITS.NEWSLETTER.limit,
    window: EMAIL_RATE_LIMITS.NEWSLETTER.window,
  });

  // Send email...
}
```

## 🧪 Test Rate Limit

### Gửi nhiều emails liên tiếp:

```bash
# Sẽ thành công lần 1-10
# Sẽ bị chặn từ lần 11

for i in {1..15}; do
  curl -X POST http://localhost:3000/api/auth/resend-activation \
    -H "Content-Type: application/json" \
    -d '{"email":"test@example.com"}'
  echo "\nRequest $i completed"
  sleep 1
done
```

### Kiểm tra Redis:

```bash
# Xem tất cả keys
redis-cli KEYS "rate_limit:*"

# Xem chi tiết một key
redis-cli ZRANGE "rate_limit:email:activation:test@example.com" 0 -1 WITHSCORES

# Xóa rate limit (reset)
redis-cli DEL "rate_limit:email:activation:test@example.com"
```

## 📚 Tài Liệu Chi Tiết

- **Full Documentation**: `src/common/services/RATE_LIMITER_README.md`
- **Examples**: `src/common/services/rate-limiter.examples.ts`
- **Summary**: `src/common/services/IMPLEMENTATION_SUMMARY.md`

## ❓ FAQ

### Q: Rate limit có hoạt động trên môi trường distributed không?

**A:** Có! Vì sử dụng Redis, rate limit hoạt động đồng bộ trên tất cả servers.

### Q: Làm sao reset rate limit cho một user?

**A:**

```typescript
await this.rateLimiter.resetLimit('email:activation:user@example.com');
```

### Q: Có thể có rate limit khác nhau cho user premium không?

**A:** Có! Xem example #5 trong `rate-limiter.examples.ts`

### Q: Tôi muốn kiểm tra rate limit mà không gửi email?

**A:**

```typescript
const result = await this.rateLimiter.checkLimit({
  key: 'email:activation:user@example.com',
  limit: 10,
  window: 60,
});

if (!result.allowed) {
  console.log('Rate limit exceeded, not sending email');
}
```

## 🎯 Next Steps

1. ✅ **Hiện tại**: Email activation và forgot password đã có rate limiting
2. 🔜 **Tiếp theo**: Thêm rate limiting cho các email khác (nếu cần)
3. 🔜 **Nâng cao**: Dashboard để monitor rate limits

---

**🎉 Hoàn thành! Rate limiting đã sẵn sàng sử dụng.**
