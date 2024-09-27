import { BadRequestException } from '@nestjs/common';

export const handleDefaultError = (error: any) => {
  if ((error.statusCode && error.message) || error.response) throw error;
  // if (error.message) throw new BadRequestException(error.message);
  throw new BadRequestException(error.message || 'Unknown error!');
};
