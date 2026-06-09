import {
  AbortMultipartUploadCommand,
  CompleteMultipartUploadCommand,
  CreateMultipartUploadCommand,
  DeleteObjectCommand,
  GetObjectCommand,
  HeadObjectCommand,
  PutObjectCommand,
  PutObjectCommandInput,
  S3Client,
  UploadPartCommand,
} from '@aws-sdk/client-s3';
import { Upload } from '@aws-sdk/lib-storage';
import { getSignedUrl } from '@aws-sdk/s3-request-presigner';
import { Injectable } from '@nestjs/common';

import { ConfigService } from '@nestjs/config';
import { MediaType } from '@prisma/client';
import axios from 'axios';
import { loadEsm } from 'load-esm';

import * as sharp from 'sharp';
import { ImageProcessOptions } from 'src/interfaces/s3.interfaces';
import { mediaDataSelect } from 'src/libs/prisma-types';
import { PrismaService } from 'src/prisma/prisma.service';

interface IAdditionalData {
  userId: string;
  postId?: string;
}

@Injectable()
export class S3Service {
  private s3Client: S3Client;
  constructor(
    private readonly configService: ConfigService,
    private readonly prismaService: PrismaService,
  ) {
    this.s3Client = new S3Client({
      region: this.configService.get('S3_REGION'),
      endpoint: this.configService.get('S3_ENDPOINT'),
      credentials: {
        accessKeyId: this.configService.get('S3_ACCESS_KEY_ID'),
        secretAccessKey: this.configService.get('S3_SECRET_ACCESS_KEY'),
      },
      forcePathStyle: true,
    });
  }

  private async processImage({
    buffer,
    options,
  }: {
    buffer: Buffer;
    options?: ImageProcessOptions;
  }) {
    const defaultOptions = {
      maxWidth: 1920,
      maxHeight: 1080,
      quality: 80,
    };

    const processedOptions = options || defaultOptions;
    const { maxWidth, maxHeight, quality } = processedOptions;

    const denyMimeTypes = ['image/gif'];
    const { fileTypeFromBuffer } =
      await loadEsm<typeof import('file-type')>('file-type');

    // Detect file type from buffer
    const fileType = await fileTypeFromBuffer(buffer);
    if (!fileType) {
      throw new Error('Could not detect image format');
    }

    if (
      !fileType?.mime.startsWith('image/') ||
      denyMimeTypes.includes(fileType.mime)
    ) {
      return buffer;
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

    return imageProcess.toBuffer();
  }

  async uploadFile(
    file: Express.Multer.File,
    name: string,
    {
      type,
      userId,
      postId,
    }: {
      type: MediaType;
    } & IAdditionalData,
  ) {
    const bucketName = this.configService.get('S3_BUCKET_NAME');
    const publicDir = this.configService.get('S3_PUBLIC_DIR');
    const key = `${publicDir}/${new Date().getFullYear()}/${Date.now()}_${name}`; // Organize files by year

    // if (fileType?.mime.startsWith('image/') && fileType.mime !== 'image/gif') {
    //   processedBuffer = await this.processImage({
    //     buffer: file.buffer,
    //     options: imageOptions,
    //   });
    //   processedSize = processedBuffer.length;
    // }

    const params: PutObjectCommandInput = {
      Bucket: bucketName,
      Key: key,
      Body: file.buffer,
      ContentLength: file.size,
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

    const data = await this.prismaService.media.create({
      data: {
        url: `${this.configService.get('S3_PUBLIC_PATH_PREFIX')}/${key}`,
        type: type || 'IMAGE',
        size: file.size,
        format: file.mimetype,
        user: {
          connect: {
            id: userId,
          },
        },
        ...(postId && {
          post: {
            connect: {
              id: postId,
            },
          },
        }),
      },
      select: mediaDataSelect,
    });

    const url = `${this.configService.get('S3_PUBLIC_PATH_PREFIX')}/${key}`;
    return { data: { ...data, uploadedFile: response }, url };
  }

  async uploadFileFromUrl(
    url: string,
    name: string,
    userId: string,
    postId?: string,
  ) {
    const response = await axios.get(url, { responseType: 'arraybuffer' });

    // Convert the downloaded data to a mock Express.Multer.File object
    const multerFile: Express.Multer.File = {
      fieldname: 'file',
      originalname: name,
      encoding: '7bit',
      mimetype: 'image/png',
      size: response.data.byteLength,
      buffer: Buffer.from(response.data),
      stream: undefined as any,
      destination: '',
      filename: name,
      path: '',
    };

    // You may need to pass userId and postId as arguments to this function or set them here
    // For now, we'll set them as undefined
    return this.uploadFile(multerFile, name, {
      type: 'IMAGE',
      userId,
      postId,
    });
  }

  async uploadFilesFromUrls(
    urls: string[],
    names: string[],
    userId: string,
    postId?: string,
  ) {
    const uploadPromises = urls.map((url, index) =>
      this.uploadFileFromUrl(url, names[index], userId, postId),
    );
    const results = await Promise.all(uploadPromises);
    return results;
  }

  async deleteFile(url: string) {
    try {
      const bucketName = this.configService.get('S3_BUCKET_NAME');
      const key = url.replace(
        `${this.configService.get('S3_PUBLIC_PATH_PREFIX')}/`,
        '',
      );
      await this.s3Client.send(
        new DeleteObjectCommand({ Bucket: bucketName, Key: key }),
      );
    } catch (error) {
      console.error(error);
      throw new Error('Failed to delete file');
    }
  }

  async deleteFiles(urls: string[]) {
    try {
      const bucketName = this.configService.get('S3_BUCKET_NAME');
      const publicPathPrefix = this.configService.get('S3_PUBLIC_PATH_PREFIX');

      // Delete files one by one
      const deletePromises = urls.map(async (url) => {
        const key = url.replace(`${publicPathPrefix}/`, '');
        console.log('Deleting key:', key);

        try {
          await this.s3Client.send(
            new DeleteObjectCommand({
              Bucket: bucketName,
              Key: key,
            }),
          );
          console.log('Successfully deleted:', key);
        } catch (err) {
          console.error(`Failed to delete ${key}:`, err);
        }
      });

      await Promise.all(deletePromises);
    } catch (error) {
      console.error('Error in deleteFiles:', error);
      throw new Error('Failed to delete files');
    }
  }

  /**
   * Upload an arbitrary file (chat attachment / voice note) directly to S3 and
   * return its public URL. Unlike {@link uploadFile} this does NOT create a
   * Media row - chat attachments aren't part of the post media gallery.
   */
  async uploadRawFile({
    file,
    name,
    userId,
  }: {
    file: Express.Multer.File;
    name: string;
    userId: string;
  }): Promise<{ url: string }> {
    const bucketName = this.configService.get('S3_BUCKET_NAME');
    const publicDir = this.configService.get('S3_PUBLIC_DIR');
    const safeName = name.replace(/[^\w.\-]+/g, '_');
    const key = `${publicDir}/chat/${userId}/${new Date().getFullYear()}/${Date.now()}_${safeName}`;

    const params: PutObjectCommandInput = {
      Bucket: bucketName,
      Key: key,
      Body: file.buffer,
      ContentLength: file.size,
      ContentType: file.mimetype,
    };

    const parallelUpload = new Upload({ client: this.s3Client, params });
    await parallelUpload.done();

    const url = `${this.configService.get('S3_PUBLIC_PATH_PREFIX')}/${key}`;
    return { url };
  }

  async uploadImage({
    file,
    name,
    imageOptions,
    userId,
    postId,
  }: {
    file: Express.Multer.File;
    name: string;
    imageOptions?: ImageProcessOptions;
  } & IAdditionalData) {
    const processedBuffer = await this.processImage({
      buffer: file.buffer,
      options: imageOptions,
    });

    file.buffer = processedBuffer;
    file.size = processedBuffer.length;

    return this.uploadFile(file, name + '.webp', {
      type: 'IMAGE',
      userId,
      postId,
    });
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

  // ==================== DIRECT (PRESIGNED) UPLOADS ====================

  /** Public URL for a stored object key. */
  buildPublicUrl(key: string): string {
    return `${this.configService.get('S3_PUBLIC_PATH_PREFIX')}/${key}`;
  }

  private get bucket(): string {
    return this.configService.get('S3_BUCKET_NAME');
  }

  /** Presigned PUT URL for uploading a single object directly from the client. */
  async presignPutObject({
    key,
    contentType,
    expiresIn = 900,
  }: {
    key: string;
    contentType: string;
    expiresIn?: number;
  }): Promise<string> {
    const command = new PutObjectCommand({
      Bucket: this.bucket,
      Key: key,
      ContentType: contentType,
    });
    return getSignedUrl(this.s3Client, command, { expiresIn });
  }

  /** Start a multipart upload, returning its uploadId. */
  async createMultipartUpload({
    key,
    contentType,
  }: {
    key: string;
    contentType: string;
  }): Promise<string> {
    const res = await this.s3Client.send(
      new CreateMultipartUploadCommand({
        Bucket: this.bucket,
        Key: key,
        ContentType: contentType,
      }),
    );
    return res.UploadId as string;
  }

  /** Presigned URL for uploading one part of a multipart upload. */
  async presignUploadPart({
    key,
    uploadId,
    partNumber,
    expiresIn = 900,
  }: {
    key: string;
    uploadId: string;
    partNumber: number;
    expiresIn?: number;
  }): Promise<string> {
    const command = new UploadPartCommand({
      Bucket: this.bucket,
      Key: key,
      UploadId: uploadId,
      PartNumber: partNumber,
    });
    return getSignedUrl(this.s3Client, command, { expiresIn });
  }

  /** Finalize a multipart upload with the ETags collected from each part. */
  async completeMultipartUpload({
    key,
    uploadId,
    parts,
  }: {
    key: string;
    uploadId: string;
    parts: { partNumber: number; etag: string }[];
  }): Promise<void> {
    await this.s3Client.send(
      new CompleteMultipartUploadCommand({
        Bucket: this.bucket,
        Key: key,
        UploadId: uploadId,
        MultipartUpload: {
          Parts: parts
            .sort((a, b) => a.partNumber - b.partNumber)
            .map((p) => ({ ETag: p.etag, PartNumber: p.partNumber })),
        },
      }),
    );
  }

  /** Abort a multipart upload (cleanup on failure). */
  async abortMultipartUpload({
    key,
    uploadId,
  }: {
    key: string;
    uploadId: string;
  }): Promise<void> {
    try {
      await this.s3Client.send(
        new AbortMultipartUploadCommand({
          Bucket: this.bucket,
          Key: key,
          UploadId: uploadId,
        }),
      );
    } catch {
      // ignore
    }
  }

  /** True when an object exists at the given key. */
  async objectExists(key: string): Promise<boolean> {
    try {
      await this.s3Client.send(
        new HeadObjectCommand({ Bucket: this.bucket, Key: key }),
      );
      return true;
    } catch {
      return false;
    }
  }

  async uploadMultipleFiles({
    files,
    names,
    userId,
  }: {
    files: Express.Multer.File[];
    names: string[];
    userId: string;
  }) {
    if (files.length !== names.length) {
      throw new Error('Number of files must match number of names');
    }

    const uploadPromises = files.map((file, index) =>
      this.uploadFile(file, names[index], {
        type: 'IMAGE',
        userId,
      }),
    );

    const results = await Promise.all(uploadPromises);
    return results;
  }

  async uploadMultipleImages({
    files,
    names,
    imageOptions,
    userId,
    postId,
  }: {
    files: Express.Multer.File[];
    names: string[];
    imageOptions?: ImageProcessOptions;
  } & IAdditionalData) {
    if (files.length !== names.length) {
      throw new Error('Number of files must match number of names');
    }

    const uploadPromises = files.map((file, index) =>
      this.uploadImage({
        file,
        name: names[index],
        imageOptions,
        userId,
        postId,
      }),
    );
    const results = await Promise.all(uploadPromises);
    return results;
  }

  async uploadPostImages({
    files,
    names,
    userId,
    postId,
  }: {
    files: Express.Multer.File[];
    names: string[];
    userId: string;
    postId: string;
  }) {
    const uploadPromises = await this.uploadMultipleImages({
      files,
      names,
      userId,
      postId,
    });
    return uploadPromises;
  }

  async deletePostImages({ postId }: { postId: string }) {
    try {
      const media = await this.prismaService.media.findMany({
        where: {
          postId,
        },
        select: {
          url: true,
        },
      });
      const urls = media.map((media) => media.url);

      await this.deleteFiles(urls);

      await this.prismaService.media.deleteMany({
        where: {
          postId,
        },
      });
    } catch (error) {
      console.error(error);
      throw new Error('Failed to delete post images');
    }
  }
}
