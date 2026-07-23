import { Controller, Get } from '@nestjs/common';
import { AppService } from './app.service';
import { ApiOperation, ApiResponse, ApiTags } from '@nestjs/swagger';

@ApiTags('System Status')
@Controller()
export class AppController {
  constructor(private readonly appService: AppService) {}

  @Get()
  @ApiOperation({ summary: 'Verifica el estado de salud de la API (Health Check)' })
  @ApiResponse({ 
    status: 200, 
    description: 'La API está en línea y funcionando correctamente.' 
  })
  getHealth() {
    return this.appService.getHealthStatus();
  }
}