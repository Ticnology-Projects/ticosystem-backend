import { Test, TestingModule } from '@nestjs/testing';
import { AuthController } from './auth.controller';
import { AuthService } from './auth.service';
import type { Request, Response } from 'express';
import { UnauthorizedException } from '@nestjs/common';

describe('AuthController', () => {
  let controller: AuthController;
  let authService: AuthService;

  // 1. Expandimos el Mock del servicio con las nuevas funciones
  const mockAuthService = {
    login: jest.fn(),
    getProfile: jest.fn(),
    refreshToken: jest.fn(),
  };

  beforeEach(async () => {
    const module: TestingModule = await Test.createTestingModule({
      controllers: [AuthController],
      providers: [
        {
          provide: AuthService,
          useValue: mockAuthService,
        },
      ],
    }).compile();

    controller = module.get<AuthController>(AuthController);
    authService = module.get<AuthService>(AuthService);
    jest.clearAllMocks();
  });

  it('debería estar definido', () => {
    expect(controller).toBeDefined();
  });

  // ==========================================
  // TESTS: LOGIN
  // ==========================================
  describe('login', () => {
    it('debería retornar tokens y configurar las cookies', async () => {
      const loginDto = { email: 'admin@ticosystem.com', password: 'password123' };
      const mockResult = {
        accessToken: 'mock_access_token',
        refreshToken: 'mock_refresh_token',
        user: { id: '1', name: 'Admin', email: 'admin@test.com', organization: 'Ticosystem' }
      };

      mockAuthService.login.mockResolvedValue(mockResult);

      const mockRequest = {
        ip: '127.0.0.1',
        headers: { 'user-agent': 'JestTestBrowser' },
        socket: { remoteAddress: '127.0.0.1' },
      } as unknown as Request;

      const mockResponse = { cookie: jest.fn() } as unknown as Response;

      const result = await controller.login(loginDto, mockRequest, mockResponse);

      expect(authService.login).toHaveBeenCalledWith(loginDto, '127.0.0.1', 'JestTestBrowser');
      expect(mockResponse.cookie).toHaveBeenCalledTimes(2);
      expect(result.accessToken).toBe('mock_access_token');
    });
  });

  // ==========================================
  // TESTS: GET PROFILE (/me)
  // ==========================================
  describe('getProfile', () => {
    it('debería llamar al servicio con el userId extraído del Request', async () => {
      // 1. Preparamos la respuesta falsa del servicio
      const mockProfile = { id: 'uuid-1', mail: 'admin@test.com', firstName: 'Admin' };
      mockAuthService.getProfile.mockResolvedValue(mockProfile);

      // 2. Simulamos el objeto Request de Express, inyectándole el "user" 
      // con el formato exacto que devuelve tu JwtStrategy
      const mockRequest = {
        user: { userId: 'uuid-1' }
      } as unknown as Request;

      // 3. Ejecutamos la función pasando el mockRequest (¡Adiós error de string!)
      const result = await controller.getProfile(mockRequest);

      // 4. Verificamos que el controlador extrajo bien el ID y llamó al servicio
      expect(authService.getProfile).toHaveBeenCalledWith('uuid-1');
      expect(result).toEqual(mockProfile);
    });
  });

  // ==========================================
  // TESTS: REFRESH TOKEN
  // ==========================================
  describe('refresh', () => {
    const mockRequest = {
      ip: '127.0.0.1',
      headers: { 'user-agent': 'JestTestBrowser' },
      socket: { remoteAddress: '127.0.0.1' },
      cookies: {},
    } as unknown as Request;
    const mockResponse = { cookie: jest.fn() } as unknown as Response;

    const mockResult = {
      accessToken: 'new_access',
      refreshToken: 'new_refresh',
    };

    it('debería extraer el token de la cookie (React)', async () => {
      mockRequest.cookies = { refresh_token: 'cookie_token' };
      mockAuthService.refreshToken.mockResolvedValue(mockResult);

      const result = await controller.refresh({ refreshToken: undefined }, mockRequest, mockResponse);

      expect(authService.refreshToken).toHaveBeenCalledWith('cookie_token', '127.0.0.1', 'JestTestBrowser');
      expect(mockResponse.cookie).toHaveBeenCalledTimes(2);
      expect(result.accessToken).toBe('new_access');
    });

    it('debería extraer el token del body si no hay cookie (Flutter)', async () => {
      mockRequest.cookies = {}; // Sin cookie
      mockAuthService.refreshToken.mockResolvedValue(mockResult);

      const result = await controller.refresh({ refreshToken: 'body_token' }, mockRequest, mockResponse);

      expect(authService.refreshToken).toHaveBeenCalledWith('body_token', '127.0.0.1', 'JestTestBrowser');
    });

    it('debería lanzar UnauthorizedException si no se envía ningún token', async () => {
      mockRequest.cookies = {}; // Sin cookie

      await expect(
        controller.refresh({ refreshToken: undefined }, mockRequest, mockResponse)
      ).rejects.toThrow(UnauthorizedException);
    });
  });
});