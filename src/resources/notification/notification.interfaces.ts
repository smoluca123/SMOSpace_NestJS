// import { Prisma } from '@prisma/client';

import { UserDataType } from 'src/libs/prisma-types';

export interface INotificationType {
  id: string;
  type: string;
}

export interface INotificationPayload {
  recipientId: string;
  senderId: string;
  senderData: UserDataType;
}

export interface INotificationFollowPayload extends INotificationPayload {}

export interface INotificationCommentPayload extends INotificationPayload {
  postId: string;
  commentId: string;
}

export interface INotificationReplyCommentPayload extends INotificationPayload {
  postId: string;
  commentId: string;
  replyCommentId: string;
}

export interface INotificationLikePayload extends INotificationPayload {
  postId: string;
}

export interface INotificationFriendRequestPayload
  extends INotificationPayload {
  friendId: string;
}

export interface INotificationFriendRequestAcceptPayload
  extends INotificationPayload {
  friendId: string;
}
