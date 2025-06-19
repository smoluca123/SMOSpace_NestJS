import { MessageType } from '@prisma/client';
import { requiredString } from 'src/libs/schemas';
import { z } from 'zod';

export const joinRoomSchema = z.object({
  roomId: requiredString({ message: 'Room ID is required' }),
});

export type JoinRoomSchema = z.infer<typeof joinRoomSchema>;

export const leaveRoomSchema = z.object({
  roomId: requiredString({ message: 'Room ID is required' }),
});

export type LeaveRoomSchema = z.infer<typeof leaveRoomSchema>;

export const sendMessageSchema = z.object({
  roomId: requiredString({ message: 'Room ID is required' }),
  content: requiredString({ message: 'Content is required' }),
  type: z.nativeEnum(MessageType).optional(),
  replyToId: z.string().optional(),
});

export type SendMessageSchema = z.infer<typeof sendMessageSchema>;
