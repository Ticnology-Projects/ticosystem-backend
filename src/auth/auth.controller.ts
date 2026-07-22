import { Controller, Post, Body, Req, Res, HttpCode, HttpStatus } from '@nestjs/common';
import { AuthService } from './auth.service';
import { LoginDto } from './dto/login.dto';
import type { Request, Response } from 'express';
import { ApiTags, ApiOperation, ApiResponse } from '@nestjs/swagger';

@ApiTags('Authentication')
@Controller('auth')
export class AuthController {
  constructor(private readonly authService: AuthService) {}

  @Post('login')
  @HttpCode(HttpStatus.OK)
  @ApiOperation({ summary: 'Inicia sesión y obtiene tokens de acceso' })
  @ApiResponse({ status: 200, description: 'Login exitoso' })
  @ApiResponse({ status: 401, description: 'Credenciales inválidas' })
  async login(
    @Body() loginDto: LoginDto, 
    @Req() req: Request, 
    @Res({ passthrough: true }) res: Response
  ) {
    // Extraer datos del cliente para auditoría
    const ipAddress = req.ip || req.socket.remoteAddress || '0.0.0.0';
    const userAgent = req.headers['user-agent'] || 'Unknown Device';

    // Procesar Login
    const result = await this.authService.login(loginDto, ipAddress, userAgent);

    // Configurar Cookie HttpOnly (Para la aplicación Web en React)
    res.cookie('refresh_token', result.refreshToken, {
      httpOnly: true, // Inaccesible desde JavaScript (Evita XSS)
      secure: process.env.NODE_ENV === 'production', // Solo HTTPS en producción
      sameSite: 'strict',
      maxAge: 7 * 24 * 60 * 60 * 1000, // 7 días en milisegundos
    });

    // Retornamos ambos tokens. 
    // React ignorará el refreshToken del JSON (usará la cookie).
    // Flutter extraerá ambos del JSON y los guardará en su almacenamiento seguro.
    return {
      message: 'Login exitoso',
      accessToken: result.accessToken,
      refreshToken: result.refreshToken, // Enviado en JSON explícitamente para Flutter
      user: result.user
    };
  }
}