import { ImageProcessOptions } from 'src/interfaces/s3.interfaces';

export const FILE_VALIDATION = {
  IMAGE: {
    MAX_SIZE: 5 * 1024 * 1024, // 5MB
    ALLOWED_TYPES: ['image/jpeg', 'image/png', 'image/gif'],
  },
  DOCUMENT: {
    MAX_SIZE: 10 * 1024 * 1024, // 10MB
    ALLOWED_TYPES: ['application/pdf', 'application/msword'],
  },
} as const;

export const IMAGE_PROCESS_OPTIONS: ImageProcessOptions = {
  maxWidth: 1920,
  maxHeight: 1080,
  quality: 80,
  format: 'jpeg',
};
