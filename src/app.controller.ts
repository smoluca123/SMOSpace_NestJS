import { Controller, Get } from '@nestjs/common';
import { AppService } from './app.service';
import { IInfoApiType } from 'src/interfaces/interface.global';

@Controller()
export class AppController {
  constructor(private readonly appService: AppService) {}

  @Get()
  getInfoApi(): IInfoApiType {
    return this.appService.getInfoApi();
  }
}
