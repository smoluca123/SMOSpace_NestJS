import { Injectable } from '@nestjs/common';
import { IInfoApiType } from 'src/interfaces/interfaces.global';

@Injectable()
export class AppService {
  constructor() {}
  getInfoApi(): IInfoApiType {
    return {
      name: 'Social Media App API',
      version: '1.0.0',
      author: 'Luca Dev',
      swagger: '/swagger',
      description: 'New Social Media API',
    };
  }
}
