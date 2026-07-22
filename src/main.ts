import 'dotenv/config'; 
import { NestFactory } from '@nestjs/core';
import { AppModule } from './app.module';
import { ValidationPipe } from '@nestjs/common';
import { AllExceptionsFilter } from './common/filters/all-exception.filter';
//import * as cookieParser from 'cookie-parser';
import { DocumentBuilder, SwaggerModule } from '@nestjs/swagger'; 

async function bootstrap() {
  const app = await NestFactory.create(AppModule);

  // Habilitar prefijo global (Opcional pero recomendado para versionamiento)
  app.setGlobalPrefix('api/v1');

  const config = new DocumentBuilder()
    .setTitle('Ticosystem API')
    .setDescription('API multitenant para gestión de facturas y servicios TI')
    .setVersion('1.0')
    .addBearerAuth() // 👈 Permitirá probar endpoints protegidos desde la interfaz de Swagger (Útil para simular a Flutter)
    .build();
  const document = SwaggerModule.createDocument(app, config);
  SwaggerModule.setup('api/docs', app, document);

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
  //app.use(cookieParser());

  // Habilitar CORS para tu frontend en Vite
  app.enableCors({
    origin: ['http://localhost:5173'], // Puerto por defecto de Vite
    credentials: true, // Permite el envío de cookies
  });

  await app.listen(3000);
  console.log(`🚀 Application is running on: http://localhost:3000/api/v1`);
  console.log(`📄 Swagger Docs available at: http://localhost:3000/api/docs`); // 👈 Log para la doc
}
bootstrap();

function cookieParser(): any {
  throw new Error('Function not implemented.');
}