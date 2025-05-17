# SMOSpace Server

SMOSpace Server is a backend API built with NestJS, providing services and API endpoints for the SMOSpace application.

## 🚀 Key Features

- User Authentication and Authorization (JWT)
- User and Profile Management
- AWS S3 Integration for File Storage
- Redis Caching System
- Email Service with MailPace
- WebSocket for Real-time Communication
- Rate Limiting and Security
- OpenAI Integration
- Database with Prisma ORM

## 🛠 Technologies Used

- **Framework**: NestJS
- **Database**: Prisma ORM
- **Cache**: Redis
- **Storage**: AWS S3
- **Email**: MailPace
- **Authentication**: JWT, Passport
- **Real-time**: Socket.IO
- **API Documentation**: Swagger
- **Testing**: Jest

## 📋 System Requirements

- Node.js (Latest LTS version)
- Bun or Yarn or npm
- Redis server
- PostgreSQL database

## 🚀 Installation

1. Clone repository:

```bash
git clone [repository-url]
cd server
```

2. Install dependencies:

```bash
# Using Bun
bun install

# Or using Yarn
yarn install

# Or using npm
npm install
```

3. Environment Configuration:

- Create `.env` file based on `.env.example`
- Fill in required environment variables

4. Run migrations:

```bash
npx prisma migrate dev
```

5. Start the server:

```bash
# Development
bun run dev
# or
yarn dev
# or
npm run dev

# Production
bun run start:prod
# or
yarn start:prod
# or
npm run start:prod
```

## 📚 API Documentation

API documentation is available at the `/api` endpoint when the server is running.

## 🧪 Testing

```bash
# Unit tests
bun run test

# e2e tests
bun run test:e2e

# Test coverage
bun run test:cov
```

## 📦 Project Structure

```
src/
├── configs/         # Application configurations
├── constants/       # Constants and enums
├── decorators/      # Custom decorators
├── guards/          # Authentication guards
├── interceptors/    # Request/Response interceptors
├── interfaces/      # TypeScript interfaces
├── jwt/            # JWT configuration
├── libs/           # Shared libraries
├── middlewares/    # Custom middlewares
├── pipes/          # Custom pipes
├── prisma/         # Prisma schema and migrations
├── resources/      # API resources and controllers
├── services/       # Business logic services
├── strategy/       # Authentication strategies
└── utils/          # Utility functions
```

## 🔒 Security

- JWT Authentication
- Rate Limiting
- CORS Protection
- Request Validation
- Secure Headers

## 🤝 Contributing

Contributions are welcome! Please read [CONTRIBUTING.md](CONTRIBUTING.md) for details on our code of conduct and the process for submitting pull requests.

## 📝 License

[MIT License](LICENSE)
