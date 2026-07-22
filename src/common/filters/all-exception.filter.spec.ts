import { AllExceptionsFilter } from './all-exception.filter';
import { ArgumentsHost, HttpException, HttpStatus } from '@nestjs/common';
import {Prisma} from '@prisma/client';

describe('AllExceptionsFilter', () => {
  let filter: AllExceptionsFilter;
  let mockResponse: any;
  let mockRequest: any;
  let mockArgumentsHost: ArgumentsHost;

  beforeEach(() => {
    filter = new AllExceptionsFilter();
    
    // Mockeamos la respuesta de Express
    mockResponse = {
      status: jest.fn().mockReturnThis(),
      json: jest.fn(),
    };
    
    // Mockeamos la request de Express
    mockRequest = {
      url: '/api/v1/test',
    };
    
    // Mockeamos el contexto de NestJS
    mockArgumentsHost = {
      switchToHttp: jest.fn().mockReturnValue({
        getResponse: () => mockResponse,
        getRequest: () => mockRequest,
      }),
    } as unknown as ArgumentsHost;
  });

  it('debería estar definido', () => {
    expect(filter).toBeDefined();
  });

  it('debería manejar HttpException devolviendo su status correspondiente', () => {
    const exception = new HttpException('Recurso no encontrado', HttpStatus.NOT_FOUND);
    
    filter.catch(exception, mockArgumentsHost);

    expect(mockResponse.status).toHaveBeenCalledWith(HttpStatus.NOT_FOUND);
    expect(mockResponse.json).toHaveBeenCalledWith(expect.objectContaining({
      statusCode: HttpStatus.NOT_FOUND,
      message: 'Recurso no encontrado',
      path: '/api/v1/test',
    }));
  });

  it('debería manejar el error de duplicidad de Prisma (P2002) devolviendo un status 409', () => {
    // Simulamos un error de Prisma
    const exception = new Prisma.PrismaClientKnownRequestError('Unique constraint failed', {
      code: 'P2002',
      clientVersion: 'x.x.x',
    });

    filter.catch(exception, mockArgumentsHost);

    expect(mockResponse.status).toHaveBeenCalledWith(HttpStatus.CONFLICT);
    expect(mockResponse.json).toHaveBeenCalledWith(expect.objectContaining({
      statusCode: HttpStatus.CONFLICT,
      message: 'Error de duplicidad: El registro ya existe.',
    }));
  });

  it('debería manejar un error genérico devolviendo status 500', () => {
    const exception = new Error('Error fatal de servidor');
    
    // Ocultamos temporalmente el console.error para no ensuciar la terminal del test
    jest.spyOn(console, 'error').mockImplementation(() => {});

    filter.catch(exception, mockArgumentsHost);

    expect(mockResponse.status).toHaveBeenCalledWith(HttpStatus.INTERNAL_SERVER_ERROR);
    expect(mockResponse.json).toHaveBeenCalledWith(expect.objectContaining({
      statusCode: HttpStatus.INTERNAL_SERVER_ERROR,
      message: 'Error interno del servidor',
    }));
  });
});