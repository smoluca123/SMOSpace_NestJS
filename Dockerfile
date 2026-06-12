# ============================================================
# Stage 1: Builder
# Install all deps, generate Prisma client, build, and fix path aliases
# ============================================================
FROM oven/bun:1 AS builder

WORKDIR /app

# Copy package manifests first to leverage Docker layer caching
COPY package.json bun.lockb ./

# Install ALL dependencies
RUN bun install --frozen-lockfile

# Copy Prisma schema before generating client
COPY prisma ./prisma

# Generate Prisma client (must run before building the app)
RUN bun prisma generate

# Copy the rest of the source code
COPY . .

# Build the NestJS application, then run tsc-alias to rewrite path aliases.
# tsc-alias converts non-relative imports like 'src/configs/configuration'
# into proper relative paths inside dist/, eliminating runtime resolution issues.
RUN bun run build && bunx tsc-alias -p tsconfig.json

# ============================================================
# Stage 2: Production runner
# ============================================================
FROM node:20-slim AS runner

WORKDIR /app

# Set Node environment to production
ENV NODE_ENV=production

# Copy package manifests and install production dependencies only
COPY package.json ./
RUN npm install --omit=dev --ignore-scripts

# Copy Prisma schema and generated client from builder
COPY --from=builder /app/prisma ./prisma
COPY --from=builder /app/node_modules/.prisma ./node_modules/.prisma

# Copy compiled application (path aliases already resolved by tsc-alias)
COPY --from=builder /app/dist ./dist

# Expose the application port (Northflank will map this)
EXPOSE 3000

# Run directly with node — no runtime path tricks needed
CMD ["node", "dist/main"]
