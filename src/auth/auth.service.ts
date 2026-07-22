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

    const accessToken = this.jwtService.sign(payload);
    
    const refreshToken = this.jwtService.sign(payload, {
      secret: process.env.JWT_REFRESH_SECRET,
      expiresIn: '7d', // El refresh dura 7 días
    });

    // 4. Calcular fecha de expiración para la BD (7 días desde ahora)
    const expiresAt = new Date();
    expiresAt.setDate(expiresAt.getDate() + 7);

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
}