import { NestFactory } from '@nestjs/core';
import { AppModule } from './app.module';
import { ValidationPipe } from '@nestjs/common';
import { AllExceptionsFilter } from './common/filters/all-exception.filter';

async function bootstrap() {
  const app = await NestFactory.create(AppModule);

  // Habilitar prefijo global (Opcional pero recomendado para versionamiento)
  app.setGlobalPrefix('api/v1');

  // Habilitar validaciones globales para los DTOs
  app.useGlobalPipes(
    new ValidationPipe({
      whitelist: true, // Remueve campos que no estén en el DTO
      forbidNonWhitelisted: true, // Lanza error si envían campos extra
      transform: true, // Transforma los tipos de datos automáticamente (Ej: string a Date)
    }),
  );

  // Filtro global de manejo de excepciones
  app.useGlobalFilters(new AllExceptionsFilter());

  // Middleware para parsear las cookies HttpOnly
  app.use(cookieParser());

  // Habilitar CORS para tu frontend en Vite
  app.enableCors({
    origin: ['http://localhost:5173'], // Puerto por defecto de Vite
    credentials: true, // Permite el envío de cookies
  });

  await app.listen(3000);
  console.log(`Application is running on: http://localhost:3000/api/v1`);
}
bootstrap();

function cookieParser(): any {
  throw new Error('Function not implemented.');
}
