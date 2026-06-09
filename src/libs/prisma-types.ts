import { Prisma } from '@prisma/client';
import type { ReactionType } from '@prisma/client';

export const userTypeDataSelect = {
  id: true,
  typeName: true,
} satisfies Prisma.UserTypeSelect;

export type UserTypeDataType = Prisma.UserTypeGetPayload<{
  select: typeof userTypeDataSelect;
}>;

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
  showOnlineStatus: true,
  createdAt: true,
  updatedAt: true,
  credits: true,
  postCount: true,
  followerCount: true,
  followingCount: true,
  friendCount: true,
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

export type UserDataWithIsFriendType = Prisma.UserGetPayload<{
  select: typeof userDataSelect;
}> & {
  isFriend: boolean;
};

export type UserDataWithStatusesType = UserDataWithIsFollowedType &
  UserDataWithIsFriendType;

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

export const mediaDataSelect = {
  id: true,
  url: true,
  type: true,
  size: true,
  format: true,
  // user: {
  //   select: userDataSelect,
  // },
  createdAt: true,
  updatedAt: true,
  height: true,
  width: true,
  duration: true,
} satisfies Prisma.MediaSelect;

const basePostDataSelect = {
  id: true,
  content: true,
  isPrivate: true,
  createdAt: true,
  updatedAt: true,
  likeCount: true,
  commentCount: true,
  shareCount: true,
  sharedPostId: true,
  media: {
    select: mediaDataSelect,
  },
  author: {
    select: userDataSelect,
  },
} satisfies Prisma.PostSelect;

/**
 * Select for an embedded shared/original post. Identical to `postDataSelect`
 * but intentionally NOT recursing into its own `sharedPost` - we only embed a
 * single level deep (a share of a share resolves to the root original).
 */
export const sharedPostDataSelect = {
  ...basePostDataSelect,
} satisfies Prisma.PostSelect;

export const postDataSelect = {
  ...basePostDataSelect,
  sharedPost: {
    select: sharedPostDataSelect,
  },
} satisfies Prisma.PostSelect;

export const postDataInclude = {
  author: {
    select: userDataSelect,
  },
} satisfies Prisma.PostInclude;

export const postLikeDataSelect = {
  id: true,
  type: true,
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

export type SharedPostDataType = Prisma.PostGetPayload<{
  select: typeof sharedPostDataSelect;
}>;

export type PostDataTypeWithLikes = PostDataType & {
  likes: PostLikeDataType[];
};

/**
 * Per-reaction-type counters for a post. Indexed by `ReactionType` so the UI
 * can render emoji breakdowns. The key set must match the Prisma enum.
 */
export type PostReactionCounts = Record<ReactionType, number>;

export type PostDataTypeWithLikeStatus = PostDataType & {
  isLiked: boolean;
  myReaction: ReactionType | null;
  reactionCounts: PostReactionCounts;
  isBookmarked?: boolean;
};

export type PostLikeDataType = Prisma.PostLikeGetPayload<{
  select: typeof postLikeDataSelect;
}>;

export type TrendingTopicType = {
  hashtag: string;
  count: number;
};

export const mediaDataInclude = {
  user: {
    select: userDataSelect,
  },
  post: {
    select: postDataSelect,
  },
} satisfies Prisma.MediaInclude;

export type MediaDataType = Prisma.MediaGetPayload<{
  select: typeof mediaDataSelect;
}>;

export type MediaDataTypeWithUser = MediaDataType & {
  user: UserDataType;
};

export type MediaDataTypeWithPost = MediaDataType & {
  post: PostDataType;
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
  likeCount: true,
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

export const postCommentLikeDataSelect = {
  id: true,
  type: true,
  createdAt: true,
  user: {
    select: userDataSelect,
  },
} satisfies Prisma.PostCommentLikeSelect;

export type PostCommentLikeDataType = Prisma.PostCommentLikeGetPayload<{
  select: typeof postCommentLikeDataSelect;
}>;

/**
 * Per-reaction-type counters for a comment. Mirrors `PostReactionCounts`.
 */
export type PostCommentReactionCounts = Record<ReactionType, number>;

export type PostCommentDataTypeWithLikeStatus = PostCommentDataType & {
  isLiked: boolean;
  myReaction: ReactionType | null;
  reactionCounts: PostCommentReactionCounts;
};

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

export const friendDataSelect = {
  id: true,
  status: true,
  userId: true,
  friendId: true,
  isRequestedByMe: true,
  createdAt: true,
  updatedAt: true,
} satisfies Prisma.FriendSelect;

export const friendDataInclude = {
  user: {
    select: userDataSelect,
  },
  friend: {
    select: userDataSelect,
  },
} satisfies Prisma.FriendInclude;

export const friendDataSelectWithInclude = {
  ...friendDataSelect,
  ...friendDataInclude,
} satisfies Prisma.FriendSelect;

export type FriendDataType = Prisma.FriendGetPayload<{
  select: typeof friendDataSelect;
}>;

export type FriendDataWithUserAndFriend = Prisma.FriendGetPayload<{
  select: typeof friendDataSelect;
  include: typeof friendDataInclude;
}>;

export const chatParticipantDataSelect = {
  id: true,
  userId: true,
  isMuted: true,
  leftAt: true,
  joinedAt: true,
  user: {
    select: {
      id: true,
      username: true,
      fullName: true,
      avatar: true,
    },
  },
} satisfies Prisma.ChatParticipantSelect;

export type ChatParticipantDataType = Prisma.ChatParticipantGetPayload<{
  select: typeof chatParticipantDataSelect;
}>;

export const chatRoomDataSelect = {
  id: true,
  status: true,
  createdAt: true,
  updatedAt: true,
  type: true,
  name: true,
  lastMessage: {
    select: {
      id: true,
      content: true,
      type: true,
      createdAt: true,
      updatedAt: true,
      sender: {
        select: {
          id: true,
          username: true,
          fullName: true,
          avatar: true,
        },
      },
    },
  },
  participants: {
    select: chatParticipantDataSelect,
  },
} satisfies Prisma.ChatRoomSelect;

export type ChatRoomDataType = Prisma.ChatRoomGetPayload<{
  select: typeof chatRoomDataSelect;
}>;

export const chatMessageDataSelect = {
  id: true,
  content: true,
  createdAt: true,
  updatedAt: true,
  isForwarded: true,
  sender: {
    select: userDataSelect,
  },
  readBy: true,
  replyTo: {
    select: {
      id: true,
      content: true,
      createdAt: true,
      updatedAt: true,
    },
  },
  type: true,
  room: {
    select: chatRoomDataSelect,
  },
  reactions: {
    select: {
      id: true,
      userId: true,
      type: true,
    },
  },
} satisfies Prisma.ChatMessageSelect;

export type ChatMessageDataType = Prisma.ChatMessageGetPayload<{
  select: typeof chatMessageDataSelect;
}>;

export const storyDataSelect = {
  id: true,
  mediaUrl: true,
  type: true,
  thumbnailUrl: true,
  duration: true,
  viewCount: true,
  createdAt: true,
  expiresAt: true,
  author: {
    select: userDataSelect,
  },
} satisfies Prisma.StorySelect;

export type StoryDataType = Prisma.StoryGetPayload<{
  select: typeof storyDataSelect;
}>;
