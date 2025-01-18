import z from 'zod';

export const subscribeOnNewComment = z.object({
  postId: z.string(),
});

export type SubscribeOnNewComment = z.infer<typeof subscribeOnNewComment>;
