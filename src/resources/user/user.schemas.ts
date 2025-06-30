import { requiredString } from 'src/libs/schemas';
import { z } from 'zod';

const generateImagesSchema = z.object({
  prompt: requiredString({ message: 'Prompt is required' }),
  numImages: z
    .number()
    .min(1, 'Number of images is required')
    .max(4, 'Number of images must be less than 4'),
  imageSize: z.enum([
    '1024x1024',
    '1344x768',
    '1280x960',
    '960x1280',
    '768x1344',
  ]),
  seed: z
    .number()
    .min(-1, 'Seed must be greater than -1')
    .max(2147483647, 'Seed must be less than 2147483647'),
});

export { generateImagesSchema };
