import * as crypto from 'crypto';

import * as bcrypt from 'bcryptjs';

import { BadRequestException } from '@nestjs/common';

export const handleDefaultError = (error: any) => {
  console.log(error);
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

export const processDataObject = async <T>(data: T): Promise<T> => {
  // Kiểm tra null/undefined hoặc không phải object
  if (!data || typeof data !== 'object') return data;

  // Xử lý riêng cho array
  if (Array.isArray(data)) {
    const processedArray = await Promise.all(
      (data as any[]).map((item) => processDataObject(item)),
    );
    return processedArray as any;
  }

  const processedData = { ...data };

  for (const key of Object.keys(processedData)) {
    const value = processedData[key];

    // Xử lý object con (không phải null và là object)
    if (value && typeof value === 'object') {
      processedData[key] = await processDataObject(value);
      continue;
    }

    // Xử lý password
    if (key === 'password' && value) {
      processedData[key] = await bcrypt.hash(value, 10);
    }
    // Chỉ set undefined cho string rỗng hoặc null/undefined
    else if (
      typeof value !== 'boolean' &&
      typeof value !== 'number' &&
      (value === null || value === undefined)
    ) {
      processedData[key] = undefined;
    }
  }

  return processedData;
};
