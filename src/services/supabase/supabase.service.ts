import { Injectable } from '@nestjs/common';
import { ConfigService } from '@nestjs/config';
import { SupabaseClient, createClient } from '@supabase/supabase-js';
import { sanitizeFileName } from 'src/global/functions.global';

@Injectable()
export class SupabaseService {
  private supabaseUrl: string;
  private supabaseKey: string;
  private supabaseBucket: string;
  private supabase: SupabaseClient<any, 'public', any>;
  constructor(private readonly configService: ConfigService) {
    this.supabaseUrl = this.configService.get('SUPABASE_URL');
    this.supabaseKey = this.configService.get('SUPABASE_KEY');
    this.supabaseBucket = this.configService.get('SUPABASE_BUCKET_NAME');
    this.supabase = createClient(this.supabaseUrl, this.supabaseKey);
  }

  async uploadFiles(files: Array<Express.Multer.File>): Promise<
    {
      id: string;
      path: string;
      fileName: string;
      fullPath: string;
      url: string;
    }[]
  > {
    try {
      const uploadPromise = files.map(async (file) => {
        const { originalname, buffer } = file;
        const fileName = new Date().getTime() + '_' + originalname;
        const sanitizedFileName = sanitizeFileName(fileName);
        const imageSupabasePath = this.configService.get('SUPABASE_IMAGE_PATH'); // Supabase path for storing image files
        const { data } = await this.supabase.storage
          .from(this.supabaseBucket)
          .upload(sanitizedFileName, buffer, {
            contentType: file.mimetype,
          });
        return {
          ...data,
          url: `${imageSupabasePath + data.fullPath}`,
          fileName: sanitizedFileName,
        };
      });

      const uploadResult = await Promise.all(uploadPromise);

      return uploadResult;
    } catch (error) {
      throw new Error(`Lỗi khi upload file: ${error.message}`);
    }
  }

  async uploadFile(file: Express.Multer.File): Promise<{
    id: string;
    path: string;
    fileName: string;
    fullPath: string;
    url: string;
  }> {
    try {
      const { originalname, buffer } = file;
      const fileName = new Date().getTime() + '_' + originalname;
      const sanitizedFileName = sanitizeFileName(fileName);
      const imageSupabasePath = this.configService.get('SUPABASE_IMAGE_PATH'); // Supabase path for storing image files
      const { data } = await this.supabase.storage
        .from(this.supabaseBucket)
        .upload(sanitizedFileName, buffer, {
          contentType: file.mimetype,
        });
      return {
        ...data,
        url: `${imageSupabasePath + data.fullPath}`,
        fileName: sanitizedFileName,
      };
    } catch (error) {
      throw new Error(`Lỗi khi upload file: ${error.message}`);
    }
  }
}
