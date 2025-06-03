import { NestFactory } from '@nestjs/core';
import { AppModule } from './app.module';
import { DocumentBuilder, SwaggerModule } from '@nestjs/swagger';
import { ValidationPipe } from '@nestjs/common';
import * as cookieParser from 'cookie-parser';
import configuration from 'src/configs/configuration';
import { HttpExceptionFilter } from './filters/http-exception.filter';
import { ResponseInterceptor } from './interceptors/response.interceptor';

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
  app.useGlobalPipes(
    new ValidationPipe({
      transform: true,
      // transformOptions: { enableImplicitConversion: true },
    }),
  );

  // Enable Cors (Cross-Origin Resource Sharing) middleware
  app.enableCors({
    origin: '*',
  });

  // Use Cookie Parser middleware
  app.use(cookieParser());

  app.useGlobalFilters(new HttpExceptionFilter());
  app.useGlobalInterceptors(new ResponseInterceptor());

  await app.listen(config.SERVER_PORT, () => {
    console.log(`Server is running on http://localhost:${config.SERVER_PORT}`);
    console.log(
      `Swagger API documentation is available at http://localhost:${config.SERVER_PORT}/swagger`,
    );
  });
}
bootstrap();
