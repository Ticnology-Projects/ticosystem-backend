import { ApiPropertyOptional } from '@nestjs/swagger';
import { IsOptional, IsString } from 'class-validator';

export class RefreshTokenDto {
  @ApiPropertyOptional({
    description: 'El refresh token. (Solo obligatorio para la App Móvil. La Web usará la Cookie).',
  })
  @IsOptional()
  @IsString()
  refreshToken?: string;
}