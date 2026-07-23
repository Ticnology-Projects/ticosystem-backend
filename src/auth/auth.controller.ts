import { Controller, Post, Body, Req, Res, HttpCode, HttpStatus, UseGuards, Get, UnauthorizedException } from '@nestjs/common';
import { AuthService } from './auth.service';
import { LoginDto } from './dto/login.dto';
import type { Request, Response } from 'express';
import { ApiTags, ApiOperation, ApiResponse, ApiBearerAuth } from '@nestjs/swagger';
import { JwtAuthGuard } from './guards/jwt-auth.guard';
import { RefreshTokenDto } from './dto/refresh-token.dto';

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
    const refreshDays = parseInt(process.env.JWT_REFRESH_EXPIRES_IN || '7', 10);
    const accessTime = parseInt(process.env.JWT_ACCESS_EXPIRES_IN || '15', 10)
    const isProduction = process.env.NODE_ENV === 'production';

    // 1. Cookie HttpOnly para el Access Token (15 minutos / Corta duración)
    res.cookie('access_token', result.accessToken, {
      httpOnly: true,
      secure: isProduction,
      sameSite: 'strict',
      maxAge: accessTime * 60 * 1000, // 15m en ms
    });

    // 2. Cookie HttpOnly para el Refresh Token (7 días / Larga duración)
    res.cookie('refresh_token', result.refreshToken, {
      httpOnly: true,
      secure: isProduction,
      sameSite: 'strict',
      maxAge: refreshDays * 24 * 60 * 60 * 1000,
    });

    // Retornamos también en el body JSON para clientes móviles (Flutter)
    return {
      message: 'Login exitoso',
      accessToken: result.accessToken,
      refreshToken: result.refreshToken,
      user: result.user
    };
  }

  @UseGuards(JwtAuthGuard) 
  @ApiBearerAuth()
  @Get('me')
  @ApiOperation({ summary: 'Obtener información del usuario actual' })
  @ApiResponse({ status: 200, description: 'Perfil obtenido exitosamente' })
  @ApiResponse({ status: 401, description: 'No autorizado' })
  async getProfile(@Req() req: Request) {
    const userId = (req.user as any).userId; 
    return this.authService.getProfile(userId);
  }

  @Post('refresh')
  @HttpCode(HttpStatus.OK)
  @ApiOperation({ summary: 'Renovar el Access Token y el Refresh Token' })
  async refresh(
    @Body() body: RefreshTokenDto,
    @Req() req: Request,
    @Res({ passthrough: true }) res: Response
  ) {
    // 1. Extraemos el token: Si es React vendrá en la cookie, si es Flutter vendrá en el Body
    const refreshToken = req.cookies?.['refresh_token'] || body.refreshToken;

    if (!refreshToken) {
      throw new UnauthorizedException('No se proporcionó un Refresh Token');
    }

    const ipAddress = req.ip || req.socket.remoteAddress || '0.0.0.0';
    const userAgent = req.headers['user-agent'] || 'Unknown Device';

    // 2. Procesar la rotación de tokens
    const result = await this.authService.refreshToken(refreshToken, ipAddress, userAgent);

    // 3. Seteamos las nuevas cookies
    const refreshDays = parseInt(process.env.JWT_REFRESH_EXPIRES_IN || '7', 10);
    const accessTime = parseInt(process.env.JWT_ACCESS_EXPIRES_IN || '15', 10);
    const isProduction = process.env.NODE_ENV === 'production';

    res.cookie('access_token', result.accessToken, {
      httpOnly: true,
      secure: isProduction,
      sameSite: 'strict',
      maxAge: accessTime * 60 * 1000,
    });

    res.cookie('refresh_token', result.refreshToken, {
      httpOnly: true,
      secure: isProduction,
      sameSite: 'strict',
      maxAge: refreshDays * 24 * 60 * 60 * 1000,
    });

    // 4. Retornamos el JSON para la App Móvil (Flutter)
    return {
      message: 'Tokens renovados exitosamente',
      accessToken: result.accessToken,
      refreshToken: result.refreshToken,
    };
  }

  @Post('logout')
  @HttpCode(HttpStatus.OK)
  @ApiOperation({ summary: 'Cierra la sesión actual revocando el Refresh Token y limpiando cookies' })
  async logout(
    @Body() body: RefreshTokenDto,
    @Req() req: Request,
    @Res({ passthrough: true }) res: Response,
  ) {
    // 1. Extracción híbrida: Cookie para Web, Body/Payload para Flutter
    const refreshToken = req.cookies?.['refresh_token'] || body.refreshToken;

    // 2. Revocar en BD (Es una operación IDEMPOTENTE: si ya estaba isRevoked = true, no falla ni rompe nada)
    if (refreshToken) {
      await this.authService.logout(refreshToken);
    }

    const isProduction = process.env.NODE_ENV === 'production';

    // 3. ENVIAR ORDEN AL NAVEGADOR PARA DESTRUIR LAS COOKIES (Crucial para Web)
    res.clearCookie('access_token', {
      httpOnly: true,
      secure: isProduction,
      sameSite: 'strict',
    });

    res.clearCookie('refresh_token', {
      httpOnly: true,
      secure: isProduction,
      sameSite: 'strict',
    });

    return { message: 'Sesión cerrada exitosamente' };
  }
}