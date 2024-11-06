import { NestFactory } from '@nestjs/core';
import { AppModule } from './app.module';
import { DocumentBuilder, SwaggerModule } from '@nestjs/swagger';
import { ValidationPipe } from '@nestjs/common';
import * as cookieParser from 'cookie-parser';
import configuration from 'src/configs/configuration';

const config = configuration();

async function bootstrap() {
  const app = await NestFactory.create(AppModule);

  const configDocument = new DocumentBuilder()
    .setTitle('Social Media API')
    .setDescription('New Social Media API')
    .setVersion('1.0.0')
    .addBearerAuth({ type: 'http', scheme: 'bearer', bearerFormat: 'JWT' })
    .build();

  const document = SwaggerModule.createDocument(app, configDocument);
  SwaggerModule.setup('/swagger', app, document);

  // Use Global Pipes to validate incoming requests
  app.useGlobalPipes(new ValidationPipe());

  // Enable Cors (Cross-Origin Resource Sharing) middleware
  app.enableCors({
    origin: [
      'http://localhost:3000',
      config.FRONTEND_URL1,
      config.FRONTEND_URL2,
      config.FRONTEND_URL3,
      config.FRONTEND_URL4,
    ],
    credentials: true,
    exposedHeaders: ['set-cookie'],
    methods: ['GET', 'POST', 'PUT', 'DELETE', 'OPTIONS'],
    allowedHeaders: ['Content-Type', 'Authorization'],
  });

  // Use Cookie Parser middleware
  app.use(cookieParser());

  await app.listen(config.SERVER_PORT, () => {
    console.log(`Server is running on http://localhost:${config.SERVER_PORT}`);
    console.log(
      `Swagger API documentation is available at http://localhost:${config.SERVER_PORT}/swagger`,
    );
  });
}
bootstrap();
