import { EntityType, NotificationType_Type } from '@prisma/client';
import { NotificationDataType } from 'src/libs/prisma-types';

/**
 * Sender summary for grouped notifications
 */
export interface ISenderSummary {
  id: string;
  username: string;
  fullName: string;
  avatar: string | null;
}

/**
 * Interface for notification group key structure
 */
export interface INotificationGroupKey {
  type: NotificationType_Type;
  entityType: EntityType | null;
  entityId: string | null;
  dateGroup: string; // YYYY-MM-DD format for grouping by day
}

/**
 * Interface for a grouped notification
 */
export interface IGroupedNotification {
  groupKey: string;
  type: {
    id: string;
    type: NotificationType_Type;
  };
  entityType: EntityType | null;
  entityId: string | null;
  count: number;
  senders: ISenderSummary[];
  content: {
    title: string;
    message: string;
  };
  metadata: Record<string, unknown>;
  priority: string;
  createdAt: Date;
  isRead: boolean;
  notificationIds: string[];
}

/**
 * Helper type for building notification groups
 */
export interface INotificationGroupBuilder {
  notifications: NotificationDataType[];
  senderMap: Map<string, ISenderSummary>;
  latestNotification: NotificationDataType;
  allRead: boolean;
}

/**
 * Type for the group map used during grouping
 */
export type NotificationGroupMap = Map<string, INotificationGroupBuilder>;

/**
 * Extract entity ID from notification metadata based on entity type
 */
export function extractEntityIdFromMetadata(
  metadata: Record<string, unknown> | null,
  entityType: EntityType | null,
): string | null {
  if (!metadata) return null;

  switch (entityType) {
    case EntityType.COMMENT:
    case EntityType.POST:
      return (metadata.postId as string) ?? null;
    case EntityType.FOLLOW:
      return (metadata.follower as { id?: string })?.id ?? null;
    case EntityType.FRIENDSHIP:
      return (metadata.friend as { id?: string })?.id ?? null;
    default:
      return null;
  }
}

/**
 * Generate group key from notification data
 */
export function generateGroupKey(
  type: NotificationType_Type,
  entityType: EntityType | null,
  entityId: string | null,
  createdAt: Date,
  groupByHours: number,
): string {
  // Create time bucket based on groupByHours
  const timeBucket = Math.floor(
    createdAt.getTime() / (groupByHours * 60 * 60 * 1000),
  );

  return `${type}_${entityType ?? 'NONE'}_${entityId ?? 'NONE'}_${timeBucket}`;
}

/**
 * Build grouped notification message based on count
 */
export function buildGroupedMessage(
  senders: ISenderSummary[],
  count: number,
  actionText: string,
): string {
  if (count === 1) {
    return `${senders[0].fullName} ${actionText}`;
  }

  if (count === 2) {
    return `${senders[0].fullName} and ${senders[1].fullName} ${actionText}`;
  }

  const othersCount = count - senders.length;
  const senderNames = senders
    .slice(0, 2)
    .map((s) => s.fullName)
    .join(', ');

  if (othersCount > 0) {
    return `${senderNames} and ${othersCount} other ${actionText}`;
  }

  return `${senderNames} ${actionText}`;
}

/**
 * Get action text based on notification type
 */
export function getActionTextByType(type: NotificationType_Type): string {
  const actionTexts: Partial<Record<NotificationType_Type, string>> = {
    [NotificationType_Type.LIKE_POST]: 'liked your post',
    [NotificationType_Type.COMMENT_POST]: 'commented on your post',
    [NotificationType_Type.REPLY_COMMENT]: 'replied to your comment',
    [NotificationType_Type.FOLLOW_USER]: 'followed you',
    [NotificationType_Type.FRIEND_REQUEST]: 'sent you a friend request',
    [NotificationType_Type.FRIEND_ACCEPT]: 'accepted your friend request',
  };

  return actionTexts[type] ?? 'đã tương tác với bạn';
}
