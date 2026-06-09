export const NOTIFICATION_MESSAGES = {
  FOLLOW_USER: {
    title: 'New Follower',
    message: '{username} started following you',
  },
  LIKE_POST: {
    title: 'New Like',
    message: '{username} liked your post',
  },
  LIKE_COMMENT: {
    title: 'New Like',
    message: '{username} liked your comment',
  },
  SHARE_POST: {
    title: 'New Share',
    message: '{username} shared your post',
  },
  COMMENT_POST: {
    title: 'New Comment',
    message: '{username} commented on your post',
  },
  REPLY_COMMENT: {
    title: 'New Reply',
    message: '{username} replied to your comment',
  },
  FRIEND_REQUEST: {
    title: 'New Friend Request',
    message: '{username} sent you a friend request',
  },
  FRIEND_ACCEPT: {
    title: 'Friend Request Accepted',
    message: '{username} accepted your friend request',
  },
  POST_MENTION: {
    title: 'Mentioned in Post',
    message: '{username} mentioned you in a post',
  },
  COMMENT_MENTION: {
    title: 'Mentioned in Comment',
    message: '{username} mentioned you in a comment',
  },
};

export const DEFAULT_NOTIFICATION_PAGE_SIZE = 10;
