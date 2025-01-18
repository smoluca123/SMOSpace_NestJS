import z from 'zod';

export const UserOnlineSchema = z.object({
  status: z.enum(['online', 'away', 'busy']).optional(),
});

export type UserOnline = z.infer<typeof UserOnlineSchema>;
