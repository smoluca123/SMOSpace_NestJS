# ============================================================
# Stage 1: Builder
# Install all deps, generate Prisma client, and build app
# ============================================================
FROM oven/bun:1 AS builder

WORKDIR /app

# Copy package manifests first to leverage Docker layer caching
COPY package.json bun.lockb ./

# Install ALL dependencies (devDeps required for build + tsconfig-paths at runtime)
RUN bun install --frozen-lockfile

# Copy Prisma schema before generating client
COPY prisma ./prisma

# Generate Prisma client (must run before building the app)
RUN bun prisma generate

# Copy the rest of the source code
COPY . .

# Build the NestJS application
RUN bun run build

# ============================================================
# Stage 2: Production runner
# ============================================================
FROM oven/bun:1-slim AS runner

WORKDIR /app

# Set Node environment to production
ENV NODE_ENV=production

# Copy the entire node_modules from builder.
# This includes devDependencies like tsconfig-paths which is required
# at runtime to resolve NestJS baseUrl path aliases (e.g. 'src/configs/...')
COPY --from=builder /app/node_modules ./node_modules

# Copy Prisma schema and compiled application
COPY --from=builder /app/prisma ./prisma
COPY --from=builder /app/dist ./dist

# Copy tsconfig so tsconfig-paths/register can read path mappings at startup
COPY --from=builder /app/tsconfig.json ./tsconfig.json
COPY --from=builder /app/tsconfig.build.json ./tsconfig.build.json

# Copy package.json (needed by some packages to resolve their own paths)
COPY package.json ./

# Expose the application port (Northflank will map this)
EXPOSE 3000

# Register tsconfig-paths at startup to resolve 'src/...' aliases in compiled JS
CMD ["node", "-r", "tsconfig-paths/register", "dist/main"]

