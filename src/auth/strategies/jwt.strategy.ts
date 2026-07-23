import { Injectable, UnauthorizedException } from '@nestjs/common';
import { PassportStrategy } from '@nestjs/passport';
import { ExtractJwt, Strategy } from 'passport-jwt';
import { Request } from 'express';

@Injectable()
export class JwtStrategy extends PassportStrategy(Strategy, 'jwt') {
  constructor() {
    super({
      jwtFromRequest: ExtractJwt.fromExtractors([
        // 1. Extraer desde Cookie HttpOnly (Para Web React)
        (req: Request) => {
          return req?.cookies?.['access_token'] || null;
        },
        // 2. Extraer desde Header Authorization: Bearer (Para App Móvil Flutter / Swagger)
        ExtractJwt.fromAuthHeaderAsBearerToken(),
      ]),
      ignoreExpiration: false,
      secretOrKey: process.env.JWT_ACCESS_SECRET || 'fallbackSecret',
    });
  }

  async validate(payload: any) {
    if (!payload) {
      throw new UnauthorizedException('Token inválido o expirado');
    }
    return { 
      userId: payload.sub, 
      email: payload.email, 
      organizationId: payload.organizationId,
      positionId: payload.positionId 
    };
  }
}