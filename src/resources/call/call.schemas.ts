import { z } from 'zod';

const requiredString = (field: string) =>
  z
    .string({ required_error: `${field} is required` })
    .min(1, `${field} is required`);

/**
 * SDP description (offer/answer). Kept loose on purpose - it's an opaque blob
 * produced by the browser's WebRTC stack that we only relay.
 */
const sessionDescriptionSchema = z.object({
  type: z.enum(['offer', 'answer', 'pranswer', 'rollback']),
  sdp: z.string(),
});

/** Start a call session in a chat room (works for both direct and group). */
export const callStartSchema = z.object({
  roomId: requiredString('Room'),
  callType: z.enum(['audio', 'video']),
});
export type CallStartSchema = z.infer<typeof callStartSchema>;

/** Reference an existing call session. */
export const callIdSchema = z.object({
  callId: requiredString('Call'),
});
export type CallIdSchema = z.infer<typeof callIdSchema>;

export const callOfferSchema = z.object({
  callId: requiredString('Call'),
  toUserId: requiredString('Target user'),
  offer: sessionDescriptionSchema,
});
export type CallOfferSchema = z.infer<typeof callOfferSchema>;

export const callAnswerSchema = z.object({
  callId: requiredString('Call'),
  toUserId: requiredString('Target user'),
  answer: sessionDescriptionSchema,
});
export type CallAnswerSchema = z.infer<typeof callAnswerSchema>;

export const callIceSchema = z.object({
  callId: requiredString('Call'),
  toUserId: requiredString('Target user'),
  // ICE candidates are opaque; the browser knows how to parse them back.
  candidate: z.any(),
});
export type CallIceSchema = z.infer<typeof callIceSchema>;
