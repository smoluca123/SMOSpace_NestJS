import { Controller, Get, UseGuards } from '@nestjs/common';
import { AppService } from './app.service';
import { IInfoApiType } from 'src/interfaces/interface.global';
import { AuthGuard } from '@nestjs/passport';
import { ApiBearerAuth } from '@nestjs/swagger';

@ApiBearerAuth()
@UseGuards(AuthGuard('jwt'))
@Controller()
export class AppController {
  constructor(private readonly appService: AppService) {}

  @Get()
  getInfoApi(): IInfoApiType {
    return this.appService.getInfoApi();
  }
}
