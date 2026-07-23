import { Test, TestingModule } from '@nestjs/testing';
import { AppController } from './app.controller';
import { AppService } from './app.service';

describe('AppController', () => {
  let appController: AppController;

  beforeEach(async () => {
    const app: TestingModule = await Test.createTestingModule({
      controllers: [AppController],
      providers: [AppService],
    }).compile();

    appController = app.get<AppController>(AppController);
  });

  describe('root', () => {
    it('debería retornar el estado de la API', () => {
      const response = appController.getHealth();
      expect(response).toHaveProperty('status', 'online');
      expect(response).toHaveProperty('name', 'Ticosystem API');
      expect(response).toHaveProperty('timestamp');
    });
  });
});