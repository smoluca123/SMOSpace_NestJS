import { Prisma } from '@prisma/client';

export const userTypeDataSelect = {
  id: true,
  typeName: true,
} satisfies Prisma.UserTypeSelect;

export const userAdditionalInfoDataSelect = {
  living: true,
  hometown: true,
  websites: true,
  jobs: true,
  birthDate: true,
} satisfies Prisma.UserAdditionalInfoSelect;

export type UserAdditionalInfoDataType = Prisma.UserAdditionalInfoGetPayload<{
  select: typeof userAdditionalInfoDataSelect;
}>;

export const userDataSelect = {
  id: true,
  username: true,
  fullName: true,
  email: true,
  bio: true,
  age: true,
  phoneNumber: true,
  isActive: true,
  isVerified: true,
  isBanned: true,
  createdAt: true,
  updatedAt: true,
  credits: true,
  postCount: true,
  followerCount: true,
  followingCount: true,
  userType: {
    select: userTypeDataSelect,
  },
  avatar: true,
  coverImage: true,
  additionalInfo: {
    select: userAdditionalInfoDataSelect,
  },
} satisfies Prisma.UserSelect;

export type UserDataType = Prisma.UserGetPayload<{
  select: typeof userDataSelect;
}>;

export type UserDataWithIsFollowedType = Prisma.UserGetPayload<{
  select: typeof userDataSelect;
}> & {
  isFollowedByUser: boolean;
};

export const userSessionDataSelect = {
  id: true,
  token: true,
  expiresAt: true,
  user: {
    select: userDataSelect,
  },
} satisfies Prisma.UserSessionSelect;

export type UserSessionDataType = Prisma.UserSessionGetPayload<{
  select: typeof userSessionDataSelect;
}>;

export const postDataSelect = {
  id: true,
  content: true,
  isPrivate: true,
  createdAt: true,
  updatedAt: true,
  likeCount: true,
  commentCount: true,
  author: {
    select: userDataSelect,
  },
} satisfies Prisma.PostSelect;

export const postDataInclude = {
  author: {
    select: userDataSelect,
  },
} satisfies Prisma.PostInclude;

export const postLikeDataSelect = {
  id: true,
  // userId: true,
  // postId: true,
  createdAt: true,
  user: {
    select: userDataSelect,
  },
  post: {
    select: postDataSelect,
  },
} satisfies Prisma.PostLikeSelect;

export type PostDataType = Prisma.PostGetPayload<{
  select: typeof postDataSelect;
  // include: typeof postDataInclude;
}>;

export type PostLikeDataType = Prisma.PostLikeGetPayload<{
  select: typeof postLikeDataSelect;
}>;

export type TrendingTopicType = {
  hashtag: string;
  count: number;
};

export const followDataSelect = {
  id: true,
  followerId: true,
  followingId: true,
  createdAt: true,
  follower: {
    select: userDataSelect,
  },
  following: {
    select: userDataSelect,
  },
} satisfies Prisma.FollowSelect;

export type FollowDataType = Prisma.FollowGetPayload<{
  select: typeof followDataSelect;
}>;

export const postCommentDataSelect = {
  id: true,
  content: true,
  level: true,
  createdAt: true,
  updatedAt: true,
  repliesCount: true,
  replyToId: true,
  post: {
    select: postDataSelect,
  },
  author: {
    select: userDataSelect,
  },
} satisfies Prisma.PostCommentSelect;

export type PostCommentDataType = Prisma.PostCommentGetPayload<{
  select: typeof postCommentDataSelect;
}>;

export const notificationDataSelect = {
  id: true,
  isRead: true,
  createdAt: true,
  type: {
    select: {
      id: true,
      type: true,
    },
  },
  priority: true,
  metadata: true,
  content: true,
  entityType: true,
  recipientId: true,
  readAt: true,
  sender: {
    select: userDataSelect,
  },
} satisfies Prisma.NotificationSelect;

export type NotificationDataType = Prisma.NotificationGetPayload<{
  select: typeof notificationDataSelect;
}>;
