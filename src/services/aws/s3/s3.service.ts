import {
  GetObjectCommand,
  PutObjectCommandInput,
  S3Client,
} from '@aws-sdk/client-s3';
import { Upload } from '@aws-sdk/lib-storage';
import { getSignedUrl } from '@aws-sdk/s3-request-presigner';
import { Injectable } from '@nestjs/common';

import { ConfigService } from '@nestjs/config';
import { loadEsm } from 'load-esm';

import * as sharp from 'sharp';
import { ImageProcessOptions } from 'src/interfaces/s3.interfaces';

@Injectable()
export class S3Service {
  private s3Client: S3Client;
  constructor(private readonly configService: ConfigService) {
    this.s3Client = new S3Client({
      region: this.configService.get('S3_REGION'),
      endpoint: this.configService.get('S3_ENDPOINT'),
      credentials: {
        accessKeyId: this.configService.get('S3_ACCESS_KEY_ID'),
        secretAccessKey: this.configService.get('S3_SECRET_ACCESS_KEY'),
      },
    });
  }

  private async processImage({
    buffer,
    options: { maxWidth = 1920, maxHeight = 1080, quality = 80 },
  }: {
    buffer: Buffer;
    options: ImageProcessOptions;
  }) {
    const { fileTypeFromBuffer } =
      await loadEsm<typeof import('file-type')>('file-type');

    // Detect file type from buffer
    const fileType = await fileTypeFromBuffer(buffer);
    if (!fileType) {
      throw new Error('Could not detect image format');
    }

    let imageProcess = sharp(buffer).resize(maxWidth, maxHeight, {
      // Fit image inside maxWidth x maxHeight dimensions while maintaining aspect ratio
      fit: 'inside',
      // Don't upscale images that are smaller than target dimensions
      withoutEnlargement: true,
    });

    imageProcess = imageProcess.toFormat(
      fileType.ext as keyof sharp.FormatEnum,
      {
        quality,
      },
    );

    // Apply format and quality
    // switch (fileType.ext) {
    //   case 'jpeg':
    //     imageProcess = imageProcess.jpeg({ quality });
    //     break;
    //   case 'png':
    //     imageProcess = imageProcess.png({ quality });
    //     break;
    //   case 'webp':
    //     imageProcess = imageProcess.webp({ quality });
    //     break;
    // }

    return imageProcess.toBuffer();
  }

  async uploadFile(
    file: Express.Multer.File,
    name: string,
    imageOptions: ImageProcessOptions,
  ) {
    const bucketName = this.configService.get('S3_BUCKET_NAME');
    const publicDir = this.configService.get('S3_PUBLIC_DIR');
    const key = `${publicDir}/${new Date().getFullYear()}/${Date.now()}_${name}`; // Organize files by year

    let processedBuffer = file.buffer;
    let processedSize = file.size;

    const { fileTypeFromBuffer } =
      await loadEsm<typeof import('file-type')>('file-type');

    const fileType = await fileTypeFromBuffer(file.buffer);

    if (fileType?.mime.startsWith('image/') && fileType.mime !== 'image/gif') {
      processedBuffer = await this.processImage({
        buffer: file.buffer,
        options: imageOptions,
      });
      processedSize = processedBuffer.length;
    }

    const params: PutObjectCommandInput = {
      Bucket: bucketName,
      Key: key,
      Body: processedBuffer,
      ContentLength: processedSize,
      ContentType: file.mimetype,
    };

    const paralellUpload = new Upload({
      client: this.s3Client,
      params,
    });

    paralellUpload.on('httpUploadProgress', (progress) => {
      console.log(progress);
    });

    const response = await paralellUpload.done();

    const url = `${this.configService.get('S3_PUBLIC_PATH_PREFIX')}/${key}`;
    return { response, url };
  }

  async getSignedUrl(key: string, { expiresIn }: { expiresIn: number }) {
    const command = new GetObjectCommand({
      Bucket: this.configService.get('S3_BUCKET_NAME'),
      Key: key,
    });
    const signedUrl = await getSignedUrl(this.s3Client, command, {
      expiresIn,
    });
    return signedUrl;
  }
}
