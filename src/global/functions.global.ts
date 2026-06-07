import * as crypto from 'crypto';

import * as bcrypt from 'bcryptjs';

import {
  BadRequestException,
  InternalServerErrorException,
} from '@nestjs/common';
import {
  PrismaClientInitializationError,
  PrismaClientKnownRequestError,
  PrismaClientUnknownRequestError,
} from '@prisma/client/runtime/library';

export const handleDefaultError = (error: any) => {
  console.log(error);
  if (
    error instanceof PrismaClientKnownRequestError ||
    error instanceof PrismaClientUnknownRequestError ||
    error instanceof PrismaClientInitializationError
  ) {
    throw new InternalServerErrorException(
      '500: Internal server error, please try again later',
    );
  }
  if ((error.statusCode && error.message) || error.response) throw error;
  // if (error.message) throw new BadRequestException(error.message);
  throw new BadRequestException(error.message || 'Unknown error!');
};

export function sanitizeFileName(fileName) {
  // Strip invalid characters: keep only letters, numbers, hyphens and underscores
  return fileName.replace(/[^a-zA-Z0-9-_\.]/g, '').replace(/[\s]/g, '_'); // Replace whitespace (space) with an underscore (_)
}

export function generateSecureVerificationCode() {
  return crypto.randomBytes(3).toString('hex').toUpperCase();
}

export const processDataObject = async <T>(data: T): Promise<T> => {
  // Bail out for null/undefined or non-object values
  if (!data || typeof data !== 'object') return data;

  // Handle arrays separately
  if (Array.isArray(data)) {
    const processedArray = await Promise.all(
      (data as any[]).map((item) => processDataObject(item)),
    );
    return processedArray as any;
  }

  const processedData = { ...data };

  for (const key of Object.keys(processedData)) {
    const value = processedData[key];

    // Recurse into nested objects (not null and is an object)
    if (value && typeof value === 'object') {
      processedData[key] = await processDataObject(value);
      continue;
    }

    // Hash password fields
    if (key === 'password' && value) {
      processedData[key] = await bcrypt.hash(value, 10);
    }
    // Only set undefined for null/undefined/empty values
    else if (
      typeof value !== 'boolean' &&
      typeof value !== 'number' &&
      (value === null || value === undefined || value === '')
    ) {
      processedData[key] = undefined;
    }
  }

  return processedData;
};
