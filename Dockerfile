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

# Expose the application port (Northflank will map this)
EXPOSE 3000

# Start the application
CMD ["bun", "run", "start:prod"]
