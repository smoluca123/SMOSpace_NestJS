# ============================================================
# Stage 1: Builder
# Install dependencies, generate Prisma client, and build app
# ============================================================
FROM oven/bun:1 AS builder

WORKDIR /app

# Copy package manifests first to leverage Docker layer caching
COPY package.json bun.lockb ./

# Install all dependencies (including devDependencies needed for build)
RUN bun install --frozen-lockfile

# Copy Prisma schema before generating client
COPY prisma ./prisma

# Generate Prisma client (required before building the app)
RUN bun prisma generate

# Copy the rest of the source code
COPY . .

# Build the NestJS application
RUN bun run build

# ============================================================
# Stage 2: Production runner
# Lean image with only runtime dependencies
# ============================================================
FROM oven/bun:1-slim AS runner

WORKDIR /app

# Set Node environment to production
ENV NODE_ENV=production

# Copy package manifests for production install
COPY package.json bun.lockb ./

# Install production dependencies only
RUN bun install --frozen-lockfile --production

# Copy Prisma schema and generated client from builder
COPY --from=builder /app/prisma ./prisma
COPY --from=builder /app/node_modules/.prisma ./node_modules/.prisma

# Copy compiled application output
COPY --from=builder /app/dist ./dist

# Copy tsconfig files so tsconfig-paths can resolve baseUrl path aliases at runtime
# This fixes "Cannot find module 'src/...'" errors caused by NestJS baseUrl imports
COPY --from=builder /app/tsconfig.json ./tsconfig.json
COPY --from=builder /app/tsconfig.build.json ./tsconfig.build.json

# Expose the application port (Northflank will map this)
EXPOSE 3000

# Use tsconfig-paths/register to resolve TypeScript path aliases (e.g. src/configs/...)
# that NestJS emits unresolved into compiled JS when using baseUrl
CMD ["node", "-r", "tsconfig-paths/register", "dist/main"]
