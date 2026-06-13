# ─── Stage 1: Builder ────────────────────────────────────────────────────────
FROM oven/bun:1-alpine AS builder

ARG DATABASE_URL
ENV NODE_ENV=build
ENV DATABASE_URL=$DATABASE_URL
WORKDIR /usr/src/app

# Copy lockfile and package manifest first for better Docker layer caching
COPY package.json bun.lockb ./

# Install exact versions from bun.lockb (equivalent to npm ci)
RUN bun install --frozen-lockfile

# Copy the rest of the application source
COPY . .

# Generate Prisma client
RUN bunx prisma generate

# Build the NestJS application
RUN bun run build

# Remove dev dependencies, keep only production deps
RUN bun install --production --frozen-lockfile

# ─── Stage 2: Production Runner ──────────────────────────────────────────────
FROM node:20-alpine
ENV NODE_ENV=production
WORKDIR /usr/src/app

# Copy only what is needed to run the built application
COPY --from=builder /usr/src/app/package.json ./
COPY --from=builder /usr/src/app/node_modules/ ./node_modules/
COPY --from=builder /usr/src/app/dist/ ./dist/
COPY --from=builder /usr/src/app/prisma/ ./prisma/

# Copy email templates (in case nest-cli.json assets config does not copy them)
COPY --from=builder /usr/src/app/src/resources/email/templates/ ./src/resources/email/templates/

# Expose the web server port
EXPOSE 3000

# Start the compiled application
CMD ["node", "dist/main"]
