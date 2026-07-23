import { Injectable, UnauthorizedException } from '@nestjs/common';
import { JwtService } from '@nestjs/jwt';
import { PrismaService } from '../prisma/prisma.service';
import { LoginDto } from './dto/login.dto';
import * as argon2 from 'argon2';

@Injectable()
export class AuthService {
  constructor(
    private prisma: PrismaService,
    private jwtService: JwtService,
  ) {}

  async login(loginDto: LoginDto, ipAddress: string, userAgent: string) {
    // 1. Buscar al usuario
    const user = await this.prisma.user.findUnique({
      where: { mail: loginDto.email },
      include: {
        organization: true,
      }
    });

    if (!user || !user.isActive) {
      throw new UnauthorizedException('Credenciales inválidas o usuario inactivo');
    }

    // 2. Verificar la contraseña con Argon2
    const isPasswordValid = await argon2.verify(user.password, loginDto.password);
    if (!isPasswordValid) {
      throw new UnauthorizedException('Credenciales inválidas');
    }

    // 3. Generar Tokens
    const payload = { 
      sub: user.id, 
      email: user.mail, 
      organizationId: user.organizationId,
      positionId: user.positionId 
    };

    const accessMinutes = parseInt(process.env.JWT_ACCESS_EXPIRES_IN || '15', 10);

    const accessToken = this.jwtService.sign(payload, {
      secret: process.env.JWT_ACCESS_SECRET,
      expiresIn: `${accessMinutes}m` //El access dura 15 minutos
    });

    const refreshDays = parseInt(process.env.JWT_REFRESH_EXPIRES_IN || '7', 10);
    
    const refreshToken = this.jwtService.sign(payload, {
      secret: process.env.JWT_REFRESH_SECRET,
      expiresIn: `${refreshDays}d`, // El refresh dura 7 días
    });

    // 4. Calcular fecha de expiración para la BD (7 días desde ahora)
    const expiresAt = new Date();
    expiresAt.setDate(expiresAt.getDate() + refreshDays);

    // 5. Guardar la sesión en la base de datos
    await this.prisma.userSession.create({
      data: {
        userId: user.id,
        refreshToken: refreshToken,
        ipAddress: ipAddress,
        userAgent: userAgent,
        expiresAt: expiresAt,
      },
    });

    // 6. Retornar datos (sin la contraseña)
    return {
      accessToken,
      refreshToken,
      user: {
        id: user.id,
        name: `${user.firstName} ${user.firstSurname}`,
        email: user.mail,
        organization: user.organization.legalName,
      }
    };
  }

  async getProfile(userId: string) {
    const user = await this.prisma.user.findUnique({
      where: { id: userId },
      select: {
        id: true,
        firstName: true,
        firstSurname: true,
        secondSurname: true,
        mail: true,
        phone: true,
        isActive: true,
        // Excluimos la contraseña por seguridad
        organization: { select: { id: true, legalName: true, countryCode: true } },
        position: { select: { id: true, name: true } },
      }
    });

    if (!user) {
      throw new UnauthorizedException('Usuario no encontrado');
    }
    return user;
  }

  async refreshToken(oldRefreshToken: string, ipAddress: string, userAgent: string) {
    try {
      // 1. Verificar firma criptográfica del token
      const payload = this.jwtService.verify(oldRefreshToken, {
        secret: process.env.JWT_REFRESH_SECRET,
      });

      // 2. Buscar la sesión en la BD por el refreshToken y el usuario
      const session = await this.prisma.userSession.findFirst({
        where: {
          refreshToken: oldRefreshToken,
          userId: payload.sub,
        },
      });

      // 🚨 DETECCIÓN DE REÚSO DE TOKEN (KILL SWITCH)
      // Si la sesión existe pero YA ESTÁ REVOCADA, alguien está intentando usar un token viejo/robado.
      if (session && session.isRevoked) {
        // Revocamos TODAS las sesiones activas del usuario inmediatamente por seguridad
        await this.prisma.userSession.updateMany({
          where: { userId: payload.sub, isRevoked: false },
          data: { isRevoked: true },
        });

        throw new UnauthorizedException(
          'Alerta de seguridad: Intento de reutilización de token detectado. Todas las sesiones han sido cerradas.',
        );
      }

      if (!session) {
        throw new UnauthorizedException('Sesión no encontrada o inválida');
      }

      // 3. Expiración Absoluta: Calcular los segundos restantes de la sesión inicial
      const now = new Date();
      const secondsLeft = Math.floor((session.expiresAt.getTime() - now.getTime()) / 1000);

      if (secondsLeft <= 0) {
        // Marcamos la sesión como revocada por expiración
        await this.prisma.userSession.update({
          where: { id: session.id },
          data: { isRevoked: true },
        });
        throw new UnauthorizedException('La sesión ha alcanzado su tiempo límite máximo');
      }

      // 4. Verificar que el usuario siga activo
      const user = await this.prisma.user.findUnique({ where: { id: payload.sub } });
      if (!user || !user.isActive) {
        throw new UnauthorizedException('Usuario inactivo o eliminado');
      }

      // 5. Generar nuevos tokens (Rotación)
      const newPayload = { 
        sub: user.id, 
        email: user.mail, 
        organizationId: user.organizationId,
        positionId: user.positionId 
      };

      const accessMinutes = parseInt(process.env.JWT_ACCESS_EXPIRES_IN || '15', 10);
      const newAccessToken = this.jwtService.sign(newPayload, {
        secret: process.env.JWT_ACCESS_SECRET,
        expiresIn: `${accessMinutes}m`,
      });

      // El nuevo refresh token HEREDA únicamente los segundos restantes de la sesión inicial
      const newRefreshToken = this.jwtService.sign(newPayload, {
        secret: process.env.JWT_REFRESH_SECRET,
        expiresIn: `${secondsLeft}s`,
      });

      // 6. Actualizar la sesión en la BD (Se rota el token, pero NO se extiende el expiresAt)
      await this.prisma.userSession.update({
        where: { id: session.id },
        data: {
          refreshToken: newRefreshToken,
          ipAddress,
          userAgent,
        },
      });

      return {
        accessToken: newAccessToken,
        refreshToken: newRefreshToken,
      };
    } catch (error) {
      if (error instanceof UnauthorizedException) {
        throw error;
      }
      throw new UnauthorizedException('Refresh token inválido, expirado o manipulado');
    }
  }

  // ==========================================
  // CIERRE DE SESIÓN (LOGOUT)
  // ==========================================
  async logout(refreshToken: string) {
    if (!refreshToken) return;

    await this.prisma.userSession.updateMany({
      where: {
        refreshToken: refreshToken,
        isRevoked: false,
      },
      data: {
        isRevoked: true,
      },
    });

    return { message: 'Sesión cerrada exitosamente' };
  }
}