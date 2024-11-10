import * as crypto from 'crypto';

import { BadRequestException } from '@nestjs/common';

export const handleDefaultError = (error: any) => {
  if ((error.statusCode && error.message) || error.response) throw error;
  // if (error.message) throw new BadRequestException(error.message);
  throw new BadRequestException(error.message || 'Unknown error!');
};

export function sanitizeFileName(fileName) {
  // Loại bỏ các ký tự không hợp lệ: chỉ giữ lại chữ cái, số, dấu gạch ngang và dấu gạch dưới
  return fileName.replace(/[^a-zA-Z0-9-_\.]/g, '').replace(/[\s]/g, '_'); // Thay thế các khoảng trắng (space) bằng dấu gạch dưới (_)
}

export function generateSecureVerificationCode() {
  return crypto.randomBytes(3).toString('hex').toUpperCase();
}
