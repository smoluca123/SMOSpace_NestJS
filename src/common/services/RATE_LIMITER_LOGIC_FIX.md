# Rate Limiter - Logic Explanation

## ❌ Lỗi Logic Cũ (Đã Fix)

### Vấn đề:

```typescript
// WRONG: Luôn thêm entry vào Redis
pipeline.zadd(redisKey, now, `${now}`);

// WRONG: resetAt luôn tính từ bây giờ
const resetAt = now + windowMs;
```

**Kết quả:**

- User gửi 10 requests → vượt limit
- User tiếp tục gửi request thứ 11, 12, 13...
- Mỗi lần gửi, entry mới được thêm vào Redis
- `resetAt` luôn là "bây giờ + 60s" → reset về 60s mỗi lần!
- **User không bao giờ gửi được email nếu cứ spam!** 💥

## ✅ Logic Mới (Đúng)

### Sliding Window với Entry Cũ Nhất

```typescript
// Step 1: Xóa entries cũ
await this.redis.zremrangebyscore(redisKey, 0, now - windowMs);

// Step 2: Đếm requests hiện tại
const count = await this.redis.zcard(redisKey);

// Step 3: Check allowed
const allowed = count < limit;

// Step 4: CHỈ thêm entry KHI ALLOWED
if (allowed) {
  await this.redis.zadd(redisKey, now, `${now}`);
}

// Step 5: resetAt từ entry CŨ NHẤT
const oldestTimestamp = await this.redis.zrange(redisKey, 0, 0, 'WITHSCORES');
const resetAt = oldestTimestamp + windowMs;
```

**Kết quả:**

- User gửi 2 requests → vượt limit (với limit=2)
- Request thứ 3 bị chặn → **KHÔNG** thêm vào Redis
- `resetAt` = timestamp của request đầu tiên + 60s
- User đợi đến `resetAt` → request đầu tiên slide ra khỏi window
- User có thể gửi lại! ✅

## 🎯 Ví Dụ Cụ Thể

### Giả sử: limit=2, window=60s

```
Timeline:
---------
00:00  →  User gửi request #1  ✅ ALLOWED (count=0)
           Redis: [req1]
           resetAt = 00:00 + 60s = 01:00

00:05  →  User gửi request #2  ✅ ALLOWED (count=1)
           Redis: [req1, req2]
           resetAt = 00:00 + 60s = 01:00 (từ req1)

00:10  →  User gửi request #3  ❌ BLOCKED (count=2)
           Redis: [req1, req2]  ← KHÔNG thêm req3
           resetAt = 00:00 + 60s = 01:00 (từ req1)

00:20  →  User spam request #4  ❌ BLOCKED (count=2)
           Redis: [req1, req2]  ← KHÔNG thêm req4
           resetAt = 00:00 + 60s = 01:00 (VẪN từ req1, KHÔNG đổi!)

00:30  →  User spam request #5  ❌ BLOCKED (count=2)
           Redis: [req1, req2]
           resetAt = 00:00 + 60s = 01:00 (VẪN không đổi!)

01:00  →  Window slide! req1 hết hạn
           Redis: [req2]  ← req1 bị xóa

01:01  →  User gửi request #6  ✅ ALLOWED (count=1)
           Redis: [req2, req6]
           resetAt = 00:05 + 60s = 01:05 (từ req2)
```

## 🔑 Key Points

### 1. Không Thêm Entry Khi Blocked

```typescript
if (allowed) {
  // ← CHỈ thêm khi allowed
  await this.redis.zadd(redisKey, now, `${now}`);
}
```

**Lý do:** Tránh spam làm reset timer

### 2. resetAt Từ Entry Cũ Nhất

```typescript
const oldestTimestamp = await this.redis.zrange(redisKey, 0, 0);
const resetAt = oldestTimestamp + windowMs;
```

**Lý do:** User biết chính xác khi nào window slide

### 3. Remaining Count

```typescript
const remaining = Math.max(0, limit - count - (allowed ? 1 : 0));
```

- Nếu `allowed=true`: trừ thêm 1 (vì sẽ add entry)
- Nếu `allowed=false`: không trừ thêm

## 📊 So Sánh Logic Cũ vs Mới

| Aspect                 | ❌ Logic Cũ        | ✅ Logic Mới    |
| ---------------------- | ------------------ | --------------- |
| Thêm entry khi blocked | ✅ Có              | ❌ Không        |
| resetAt tính từ        | Thời điểm hiện tại | Entry cũ nhất   |
| Spam request           | Reset timer về 60s | Timer không đổi |
| User recovery          | Không bao giờ      | Đúng sau window |

## 🧪 Test Cases

### Test 1: Vượt limit và spam

```typescript
// Send 2 requests (limit=2)
await rateLimiter.enforceLimit({ key: 'test', limit: 2, window: 60 });
await rateLimiter.enforceLimit({ key: 'test', limit: 2, window: 60 });

// Get resetAt
const result1 = await rateLimiter.checkLimit({
  key: 'test',
  limit: 2,
  window: 60,
});
const firstResetAt = result1.resetAt;

// Spam 10 more requests
for (let i = 0; i < 10; i++) {
  const result = await rateLimiter.checkLimit({
    key: 'test',
    limit: 2,
    window: 60,
  });
  console.log(result.resetAt === firstResetAt); // ✅ true - không đổi!
}
```

### Test 2: Window slide

```typescript
// Send 2 requests
await rateLimiter.enforceLimit({ key: 'test', limit: 2, window: 2 });
await rateLimiter.enforceLimit({ key: 'test', limit: 2, window: 2 });

// 3rd request blocked
await expect(
  rateLimiter.enforceLimit({ key: 'test', limit: 2, window: 2 }),
).rejects.toThrow();

// Wait for window to slide
await sleep(2000);

// Should be allowed now
await expect(
  rateLimiter.enforceLimit({ key: 'test', limit: 2, window: 2 }),
).resolves.not.toThrow(); // ✅ OK
```

## 💡 Best Practices

### 1. Frontend Handling

```typescript
try {
  await sendEmail(email);
} catch (error) {
  if (error.status === 429) {
    const retryAfter = error.response.data.retryAfter;

    // Show countdown timer
    let remaining = retryAfter;
    const timer = setInterval(() => {
      remaining--;
      console.log(`Retry in ${remaining}s`);

      if (remaining <= 0) {
        clearInterval(timer);
        // Enable send button
      }
    }, 1000);
  }
}
```

### 2. Server-side Pre-check

```typescript
// Check before attempting
const result = await rateLimiter.checkLimit({
  key: `email:${email}`,
  limit: 10,
  window: 60,
});

if (!result.allowed) {
  return {
    success: false,
    message: `Rate limit exceeded. Try again in ${Math.ceil((result.resetAt - Date.now()) / 1000)}s`,
    retryAfter: result.resetAt,
  };
}

// Proceed with sending
```

## 📝 Changelog

- **v1.0.0**: Initial implementation (có bug)
- **v1.1.0**: 🐛 Fixed critical bug - resetAt không còn reset về window duration
  - Chỉ thêm entry khi allowed
  - resetAt tính từ entry cũ nhất
  - Remaining count chính xác hơn
