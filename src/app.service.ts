import { Injectable } from '@nestjs/common';
import { IInfoApiType } from 'src/interfaces/interface.global';

@Injectable()
export class AppService {
  constructor() {}
  getInfoApi(): IInfoApiType {
    return {
      name: 'Discord API',
      version: '1.0.0',
      author: 'Luca Dev',
      swagger: '/swagger',
      description: 'New Discord API',
    };
  }
}
