import { Controller, Get } from '@nestjs/common';
import { AppService } from './app.service';
import { IInfoApiType } from 'src/interfaces/interface.global';
import { Cookies } from 'src/decorators/cookies.decorator';

@Controller()
export class AppController {
  constructor(private readonly appService: AppService) {}

  @Get()
  getInfoApi(@Cookies('accessToken') accessTokenCookie: string): IInfoApiType {
    console.log(accessTokenCookie);
    return this.appService.getInfoApi();
  }
}
