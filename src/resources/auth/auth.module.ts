import { Module } from '@nestjs/common';
import { AuthService } from './auth.service';
import { AuthController } from './auth.controller';
import { HttpModule } from '@nestjs/axios';
// import * as https from 'https';

@Module({
  imports: [
    HttpModule.register({
      timeout: 5000,
      maxRedirects: 5,
      // httpsAgent: new https.Agent({
      //   secureProtocol: 'TLSv1_1_method', // hoặc 'TLSv1_3_method' nếu server hỗ trợ
      // }),
      proxy: {
        host: '103.172.116.30',
        port: 3128,
        auth: {
          username: 'admin',
          password: 'Luca123',
        },
      },
    }),
  ],
  controllers: [AuthController],
  providers: [AuthService],
})
export class AuthModule {}
