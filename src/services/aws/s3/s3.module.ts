import { Global, Module } from '@nestjs/common';
import { S3Service } from 'src/services/aws/s3/s3.service';

@Global()
@Module({
  imports: [],
  controllers: [],
  providers: [S3Service],
  exports: [S3Service],
})
export class S3Module {}
