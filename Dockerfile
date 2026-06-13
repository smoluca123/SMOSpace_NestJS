# Initiate a container to build the application in.
FROM node:20-alpine AS builder
ARG DATABASE_URL
ENV NODE_ENV=build
ENV DATABASE_URL=$DATABASE_URL
WORKDIR /usr/src/app

# Copy the package.json into the container.
COPY package*.json ./

# Install the dependencies required to build the application.
RUN npm install --legacy-peer-deps

# Copy the application source into the container.
COPY . .

# Generate Prisma client
RUN npx prisma generate --schema=./prisma/schema

# Build the application.
RUN npm run build

# Uninstall the dependencies not required to run the built application.
RUN npm prune --production --force

# Initiate a new container to run the application in.
FROM node:20-alpine
ENV NODE_ENV=production
WORKDIR /usr/src/app

# Copy everything required to run the built application into the new container.
COPY --from=builder /usr/src/app/package*.json ./
COPY --from=builder /usr/src/app/node_modules/ ./node_modules/
COPY --from=builder /usr/src/app/dist/ ./dist/
COPY --from=builder /usr/src/app/prisma/ ./prisma/
# Copy email templates (fallback if nest-cli.json assets config doesn't work)
COPY --from=builder /usr/src/app/src/modules/mail/templates/ ./src/modules/mail/templates/

# Expose the web server's port.
EXPOSE 3000

# Run the application.
CMD ["node", "dist/main"]
