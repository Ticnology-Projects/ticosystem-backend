import { Test, TestingModule } from '@nestjs/testing';
import { AuthService } from './auth.service';
import { PrismaService } from '../prisma/prisma.service';
import { JwtService } from '@nestjs/jwt';
import { UnauthorizedException } from '@nestjs/common';
import * as argon2 from 'argon2';

jest.mock('argon2');

describe('AuthService', () => {
  let service: AuthService;
  let prisma: PrismaService;
  let jwtService: JwtService;

  const mockPrismaService = {
    user: {
      findUnique: jest.fn(),
    },
    userSession: {
      create: jest.fn(),
      findFirst: jest.fn(),
      update: jest.fn(),
      updateMany: jest.fn(),
    },
  };

  const mockJwtService = {
    sign: jest.fn(),
    verify: jest.fn(),
  };

  const mockUser = {
    id: 'uuid-user-1',
    mail: 'admin@ticosystem.com',
    password: 'hashed_password',
    isActive: true,
    organizationId: 'uuid-org-1',
    positionId: 'uuid-pos-1',
    firstName: 'Super',
    firstSurname: 'Admin',
    organization: {
      legalName: 'Ticosystem S.A.',
    },
  };

  beforeEach(async () => {
    const module: TestingModule = await Test.createTestingModule({
      providers: [
        AuthService,
        { provide: PrismaService, useValue: mockPrismaService },
        { provide: JwtService, useValue: mockJwtService },
      ],
    }).compile();

    service = module.get<AuthService>(AuthService);
    prisma = module.get<PrismaService>(PrismaService);
    jwtService = module.get<JwtService>(JwtService);

    jest.clearAllMocks();
  });

  it('debería estar definido', () => {
    expect(service).toBeDefined();
  });

  // ==========================================
  // TESTS: LOGIN
  // ==========================================
  describe('login', () => {
    const loginDto = { email: 'admin@ticosystem.com', password: 'Admin123!' };

    it('debería realizar el login correctamente con credenciales válidas', async () => {
      mockPrismaService.user.findUnique.mockResolvedValue(mockUser);
      (argon2.verify as jest.Mock).mockResolvedValue(true);
      mockJwtService.sign.mockReturnValue('mock_jwt_token');
      mockPrismaService.userSession.create.mockResolvedValue({});

      const result = await service.login(loginDto, '127.0.0.1', 'Mozilla/5.0');

      expect(result).toHaveProperty('accessToken', 'mock_jwt_token');
      expect(result).toHaveProperty('refreshToken', 'mock_jwt_token');
    });
  });

  // ==========================================
  // TESTS: GET PROFILE
  // ==========================================
  describe('getProfile', () => {
    it('debería retornar el perfil del usuario', async () => {
      mockPrismaService.user.findUnique.mockResolvedValue(mockUser);
      const result = await service.getProfile('uuid-user-1');
      expect(result).toEqual(mockUser);
    });
  });

  // ==========================================
  // TESTS: REFRESH TOKEN (SEGURIDAD Y EXPIRACIÓN ABSOLUTA)
  // ==========================================
  describe('refreshToken', () => {
    const mockSession = {
      id: 'session-1',
      userId: 'uuid-user-1',
      refreshToken: 'old_refresh_token',
      isRevoked: false,
      expiresAt: new Date(Date.now() + 3600000), // Vence en 1 hora (futuro)
    };

    it('debería rotar tokens heredando la expiración restante', async () => {
      mockJwtService.verify.mockReturnValue({ sub: 'uuid-user-1' });
      mockPrismaService.userSession.findFirst.mockResolvedValue(mockSession);
      mockPrismaService.user.findUnique.mockResolvedValue(mockUser);
      mockJwtService.sign.mockReturnValue('new_jwt_token');

      const result = await service.refreshToken('old_refresh_token', '127.0.0.1', 'Jest');

      expect(result.accessToken).toBe('new_jwt_token');
      expect(result.refreshToken).toBe('new_jwt_token');
      expect(mockPrismaService.userSession.update).toHaveBeenCalledWith({
        where: { id: 'session-1' },
        data: {
          refreshToken: 'new_jwt_token',
          ipAddress: '127.0.0.1',
          userAgent: 'Jest',
        },
      });
    });

    it('🚨 Detección de Reúso: Debería revocar TODAS las sesiones si se reusa un token ya revocado', async () => {
      mockJwtService.verify.mockReturnValue({ sub: 'uuid-user-1' });
      // Simulamos que la sesión fue encontrada pero YA ESTABA REVOCADA
      mockPrismaService.userSession.findFirst.mockResolvedValue({
        ...mockSession,
        isRevoked: true,
      });

      await expect(
        service.refreshToken('reused_old_token', '127.0.0.1', 'HackerBrowser'),
      ).rejects.toThrow(
        'Alerta de seguridad: Intento de reutilización de token detectado. Todas las sesiones han sido cerradas.',
      );

      // Verifica que ejecutó la revocación masiva
      expect(mockPrismaService.userSession.updateMany).toHaveBeenCalledWith({
        where: { userId: 'uuid-user-1', isRevoked: false },
        data: { isRevoked: true },
      });
    });

    it('Expiración Absoluta: Debería fallar si la sesión superó su fecha límite límite máximo', async () => {
      mockJwtService.verify.mockReturnValue({ sub: 'uuid-user-1' });
      // Sesión expirada en el pasado
      const expiredSession = {
        ...mockSession,
        expiresAt: new Date(Date.now() - 1000),
      };
      mockPrismaService.userSession.findFirst.mockResolvedValue(expiredSession);

      await expect(service.refreshToken('old_refresh_token', '127.0.0.1', 'Jest')).rejects.toThrow(
        'La sesión ha alcanzado su tiempo límite máximo',
      );
    });
  });

  // ==========================================
  // TESTS: LOGOUT
  // ==========================================
  describe('logout', () => {
    it('debería revocar la sesión enviada', async () => {
      mockPrismaService.userSession.updateMany.mockResolvedValue({ count: 1 });

      const result = await service.logout('refresh_token_to_logout');

      expect(mockPrismaService.userSession.updateMany).toHaveBeenCalledWith({
        where: { refreshToken: 'refresh_token_to_logout', isRevoked: false },
        data: { isRevoked: true },
      });
      expect(result).toEqual({ message: 'Sesión cerrada exitosamente' });
    });
  });
});