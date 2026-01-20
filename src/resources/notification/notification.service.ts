import { Injectable } from '@nestjs/common';
import {
  EntityType,
  NotificationPriority,
  NotificationType_Type,
  Prisma,
} from '@prisma/client';
import { handleDefaultError } from 'src/global/functions.global';
import {
  IBeforeTransformResponseType,
  IPaginationResponseType,
  IResponseType,
} from 'src/interfaces/interfaces.global';
import {
  notificationDataSelect,
  NotificationDataType,
} from 'src/libs/prisma-types';
import { PrismaService } from 'src/prisma/prisma.service';
import { NOTIFICATION_MESSAGES } from 'src/resources/notification/notification.contants';
import { NotificationGateway } from 'src/resources/notification/notification.gateway';
import {
  INotificationCommentPayload,
  INotificationFollowPayload,
  INotificationFriendRequestPayload,
  INotificationLikePayload,
  INotificationReplyCommentPayload,
} from 'src/resources/notification/notification.interfaces';
import {
  extractEntityIdFromMetadata,
  generateGroupKey,
  getActionTextByType,
  IGroupedNotification,
  ISenderSummary,
  NotificationGroupMap,
} from 'src/resources/notification/notification-group.interface';

@Injectable()
export class NotificationService {
  constructor(
    private readonly prisma: PrismaService,
    private readonly notificationGateway: NotificationGateway,
  ) {}

  // ==================== PRIVATE HELPERS ====================

  /**
   * Format message template with params
   */
  private formatMessage(
    template: string,
    params: Record<string, string>,
  ): string {
    let message = template;
    Object.entries(params).forEach(([key, value]) => {
      message = message.replace(`{${key}}`, value);
    });
    return message;
  }

  /**
   * Build notification type connectOrCreate object
   */
  private buildNotificationTypeConnect(type: NotificationType_Type) {
    return {
      connectOrCreate: {
        where: { type },
        create: { type },
      },
    };
  }

  /**
   * Create or update notification (upsert pattern)
   * Prevents duplicate notifications for same sender-recipient-type combo
   */
  private async createOrUpdateNotification(
    data: Prisma.NotificationCreateInput,
    recipientId: string,
    senderId: string,
    type: NotificationType_Type,
    shouldEmit = true,
  ): Promise<NotificationDataType | undefined> {
    const existingNotification = await this.prisma.notification.findFirst({
      where: {
        recipientId,
        senderId,
        type: { type },
      },
    });

    if (existingNotification) {
      const updated = await this.prisma.notification.update({
        where: { id: existingNotification.id },
        data,
        select: notificationDataSelect,
      });
      return updated;
    }

    const newNotification = await this.prisma.notification.create({
      data,
      select: notificationDataSelect,
    });

    if (shouldEmit) {
      this.notificationGateway.emitNewNotification(newNotification);
    }

    return newNotification;
  }

  // ==================== CRUD OPERATIONS ====================

  async createNotification(data: Prisma.NotificationCreateInput) {
    try {
      return this.prisma.notification.create({
        data,
        select: notificationDataSelect,
      });
    } catch (error) {
      handleDefaultError(error);
    }
  }

  async deleteNotification(id: string) {
    try {
      return await this.prisma.notification.update({
        where: { id },
        data: { isDeleted: true },
      });
    } catch (error) {
      handleDefaultError(error);
    }
  }

  async deleteNotifications(ids: string[]) {
    try {
      return await this.prisma.notification.updateMany({
        where: { id: { in: ids } },
        data: { isDeleted: true },
      });
    } catch (error) {
      handleDefaultError(error);
    }
  }

  // ==================== COMMENT NOTIFICATIONS ====================

  async deleteCommentNotification({
    recipientId,
    senderId,
    postId,
    commentId,
  }: {
    recipientId: string;
    senderId: string;
    postId: string;
    commentId: string;
  }) {
    try {
      const notification = await this.prisma.notification.findFirst({
        where: {
          type: {
            type: {
              in: [
                NotificationType_Type.COMMENT_POST,
                NotificationType_Type.REPLY_COMMENT,
                NotificationType_Type.COMMENT_MENTION,
              ],
            },
          },
          ...(postId && {
            AND: [
              { metadata: { path: ['postId'], equals: postId } },
              { metadata: { path: ['commentId'], equals: commentId } },
            ],
          }),
          entityType: EntityType.COMMENT,
          isDeleted: false,
          recipientId,
          senderId,
        },
      });

      if (!notification) return;
      return await this.deleteNotification(notification.id);
    } catch (error) {
      handleDefaultError(error);
    }
  }

  async createCommentNotification(payload: INotificationCommentPayload) {
    try {
      // Skip if sender is recipient (self-comment)
      if (payload.senderId === payload.recipientId) return;

      const message = this.formatMessage(
        NOTIFICATION_MESSAGES.COMMENT_POST.message,
        { username: payload.senderData.username },
      );

      const newNotification = await this.prisma.notification.create({
        data: {
          content: {
            title: NOTIFICATION_MESSAGES.COMMENT_POST.title,
            message,
          },
          entityType: EntityType.COMMENT,
          metadata: {
            postId: payload.postId,
            commentId: payload.commentId,
            commentAuthor: {
              username: payload.senderData.username,
              fullName: payload.senderData.fullName,
              avatar: payload.senderData.avatar,
            },
          },
          priority: NotificationPriority.NORMAL,
          type: this.buildNotificationTypeConnect(
            NotificationType_Type.COMMENT_POST,
          ),
          sender: { connect: { id: payload.senderId } },
          recipient: { connect: { id: payload.recipientId } },
        },
        select: notificationDataSelect,
      });

      this.notificationGateway.emitNewNotification(newNotification);
      return newNotification;
    } catch (error) {
      handleDefaultError(error);
    }
  }

  async createReplyCommentNotification(
    payload: INotificationReplyCommentPayload,
  ) {
    try {
      // Skip if sender is recipient (self-reply)
      if (payload.senderId === payload.recipientId) return;

      const message = this.formatMessage(
        NOTIFICATION_MESSAGES.REPLY_COMMENT.message,
        { username: payload.senderData.username },
      );

      const newNotification = await this.prisma.notification.create({
        data: {
          content: {
            title: NOTIFICATION_MESSAGES.REPLY_COMMENT.title,
            message,
          },
          entityType: EntityType.COMMENT,
          metadata: {
            postId: payload.postId,
            commentId: payload.commentId,
            commentAuthor: {
              username: payload.senderData.username,
              fullName: payload.senderData.fullName,
              avatar: payload.senderData.avatar,
            },
          },
          priority: NotificationPriority.NORMAL,
          type: this.buildNotificationTypeConnect(
            NotificationType_Type.REPLY_COMMENT,
          ),
          sender: { connect: { id: payload.senderId } },
          recipient: { connect: { id: payload.recipientId } },
        },
        select: notificationDataSelect,
      });

      this.notificationGateway.emitNewNotification(newNotification);
      return newNotification;
    } catch (error) {
      handleDefaultError(error);
    }
  }

  // ==================== LIKE POST NOTIFICATIONS ====================

  async createLikePostNotification(payload: INotificationLikePayload) {
    try {
      // Skip if sender is recipient (self-like)
      if (payload.senderId === payload.recipientId) return;

      const message = this.formatMessage(
        NOTIFICATION_MESSAGES.LIKE_POST.message,
        { username: payload.senderData.username },
      );

      const newNotification = await this.prisma.notification.create({
        data: {
          content: {
            title: NOTIFICATION_MESSAGES.LIKE_POST.title,
            message,
          },
          entityType: EntityType.POST,
          metadata: {
            postId: payload.postId,
            liker: {
              username: payload.senderData.username,
              fullName: payload.senderData.fullName,
              avatar: payload.senderData.avatar,
            },
          },
          priority: NotificationPriority.NORMAL,
          type: this.buildNotificationTypeConnect(
            NotificationType_Type.LIKE_POST,
          ),
          sender: { connect: { id: payload.senderId } },
          recipient: { connect: { id: payload.recipientId } },
        },
        select: notificationDataSelect,
      });

      this.notificationGateway.emitNewNotification(newNotification);
      return newNotification;
    } catch (error) {
      handleDefaultError(error);
    }
  }

  async deleteLikePostNotification({
    recipientId,
    senderId,
    postId,
  }: {
    recipientId: string;
    senderId: string;
    postId: string;
  }) {
    try {
      const notification = await this.prisma.notification.findFirst({
        where: {
          type: {
            type: NotificationType_Type.LIKE_POST,
          },
          metadata: { path: ['postId'], equals: postId },
          entityType: EntityType.POST,
          isDeleted: false,
          recipientId,
          senderId,
        },
      });

      if (!notification) return;
      return await this.deleteNotification(notification.id);
    } catch (error) {
      handleDefaultError(error);
    }
  }

  // ==================== FOLLOW NOTIFICATIONS ====================

  async createFollowNotification(payload: INotificationFollowPayload) {
    try {
      const message = this.formatMessage(
        NOTIFICATION_MESSAGES.FOLLOW_USER.message,
        { username: payload.senderData.username },
      );

      const notificationData: Prisma.NotificationCreateInput = {
        isDeleted: false,
        content: {
          title: NOTIFICATION_MESSAGES.FOLLOW_USER.title,
          message,
        },
        entityType: EntityType.FOLLOW,
        metadata: {
          follower: {
            id: payload.senderData.id,
            username: payload.senderData.username,
            fullName: payload.senderData.fullName,
            avatar: payload.senderData.avatar,
          },
        },
        priority: NotificationPriority.NORMAL,
        readAt: null,
        isRead: false,
        type: this.buildNotificationTypeConnect(
          NotificationType_Type.FOLLOW_USER,
        ),
        createdAt: new Date(),
        sender: { connect: { id: payload.senderId } },
        recipient: { connect: { id: payload.recipientId } },
      };

      return await this.createOrUpdateNotification(
        notificationData,
        payload.recipientId,
        payload.senderId,
        NotificationType_Type.FOLLOW_USER,
      );
    } catch (error) {
      handleDefaultError(error);
    }
  }

  async deleteFollowNotification(payload: {
    recipientId: string;
    senderId: string;
  }) {
    try {
      // Use soft delete for consistency
      await this.prisma.notification.updateMany({
        where: {
          recipientId: payload.recipientId,
          senderId: payload.senderId,
          type: { type: NotificationType_Type.FOLLOW_USER },
          isDeleted: false,
        },
        data: { isDeleted: true },
      });
    } catch (error) {
      handleDefaultError(error);
    }
  }

  // ==================== FRIEND REQUEST NOTIFICATIONS ====================

  async createFriendRequestNotification(
    payload: INotificationFriendRequestPayload,
  ) {
    try {
      const message = this.formatMessage(
        NOTIFICATION_MESSAGES.FRIEND_REQUEST.message,
        { username: payload.senderData.username },
      );

      const notificationData: Prisma.NotificationCreateInput = {
        isDeleted: false,
        content: {
          title: NOTIFICATION_MESSAGES.FRIEND_REQUEST.title,
          message,
        },
        entityType: EntityType.FRIENDSHIP,
        metadata: {
          friend: {
            id: payload.friendId,
            username: payload.senderData.username,
            fullName: payload.senderData.fullName,
            avatar: payload.senderData.avatar,
          },
        },
        priority: NotificationPriority.NORMAL,
        readAt: null,
        isRead: false,
        type: this.buildNotificationTypeConnect(
          NotificationType_Type.FRIEND_REQUEST,
        ),
        createdAt: new Date(),
        sender: { connect: { id: payload.senderId } },
        recipient: { connect: { id: payload.recipientId } },
      };

      return await this.createOrUpdateNotification(
        notificationData,
        payload.recipientId,
        payload.senderId,
        NotificationType_Type.FRIEND_REQUEST,
      );
    } catch (error) {
      handleDefaultError(error);
    }
  }

  async deleteFriendRequestNotifications({
    userId,
    friendId,
  }: {
    userId: string;
    friendId: string;
  }): Promise<IResponseType<null>> {
    try {
      // Use soft delete for consistency
      await this.prisma.notification.updateMany({
        where: {
          senderId: userId,
          recipientId: friendId,
          metadata: { path: ['friend', 'id'], equals: friendId },
          type: { type: NotificationType_Type.FRIEND_REQUEST },
          isDeleted: false,
        },
        data: { isDeleted: true },
      });

      return {
        message: 'Friend request notifications deleted successfully',
        data: null,
        statusCode: 204,
        date: new Date(),
      };
    } catch (error) {
      handleDefaultError(error);
    }
  }

  // ==================== POST RELATED NOTIFICATIONS ====================

  async deletePostRelatedNotifications(
    postId: string,
  ): Promise<IResponseType<null>> {
    try {
      // Use soft delete for consistency
      await this.prisma.notification.updateMany({
        where: {
          metadata: { path: ['postId'], equals: postId },
          isDeleted: false,
        },
        data: { isDeleted: true },
      });

      return {
        message: 'Post related notifications deleted successfully',
        data: null,
        statusCode: 204,
        date: new Date(),
      };
    } catch (error) {
      handleDefaultError(error);
    }
  }

  // ==================== QUERY & STATUS ====================

  async getNotifications({
    userId,
    page,
    limit,
    isRead,
    typeId,
  }: {
    userId: string;
    page: number;
    limit: number;
    isRead?: boolean;
    typeId?: string;
  }): Promise<IPaginationResponseType<NotificationDataType>> {
    try {
      const whereQuery: Prisma.NotificationWhereInput = {
        recipientId: userId,
        ...(isRead !== undefined && { isRead }),
        ...(typeId !== undefined && { typeId }),
        isDeleted: false,
      };

      const [notifications, totalCount] = await this.prisma.$transaction([
        this.prisma.notification.findMany({
          where: whereQuery,
          skip: (page - 1) * limit,
          take: limit,
          select: notificationDataSelect,
          orderBy: { createdAt: 'desc' },
        }),
        this.prisma.notification.count({ where: whereQuery }),
      ]);

      const totalPage = Math.ceil(totalCount / limit);
      const hasNextPage = page * limit < totalCount;
      const hasPreviousPage = !!totalCount && page > 1;

      return {
        message: 'Notifications fetched successfully',
        data: {
          currentPage: page,
          items: notifications,
          totalCount,
          totalPage,
          pageSize: limit,
          hasNextPage,
          hasPreviousPage,
        },
        statusCode: 200,
        date: new Date(),
      };
    } catch (error) {
      handleDefaultError(error);
    }
  }

  async changeNotificationStatus({
    notificationId,
    isRead,
  }: {
    notificationId: string;
    isRead: boolean;
  }): Promise<IBeforeTransformResponseType<NotificationDataType>> {
    try {
      const notification = await this.prisma.notification.update({
        where: { id: notificationId },
        data: { isRead, readAt: isRead ? new Date() : null },
        select: notificationDataSelect,
      });

      return {
        type: 'response',
        message: 'Notification status changed successfully',
        data: notification,
      };
    } catch (error) {
      handleDefaultError(error);
    }
  }

  // ==================== GROUPED NOTIFICATIONS ====================

  /**
   * Build sender summary from notification
   */
  private buildSenderSummary(
    notification: NotificationDataType,
  ): ISenderSummary | null {
    if (!notification.sender) return null;

    return {
      id: notification.sender.id,
      username: notification.sender.username,
      fullName: notification.sender.fullName,
      avatar: notification.sender.avatar,
    };
  }

  /**
   * Get notifications grouped by type, entity, and time
   */
  async getGroupedNotifications({
    userId,
    page,
    limit,
    groupByTime = 24,
  }: {
    userId: string;
    page: number;
    limit: number;
    groupByTime?: number;
  }): Promise<IPaginationResponseType<IGroupedNotification>> {
    try {
      // Fetch more notifications than limit to build groups properly
      // We fetch up to 200 recent notifications for grouping
      const maxFetchLimit = Math.max(limit * 20, 200);

      const notifications = await this.prisma.notification.findMany({
        where: {
          recipientId: userId,
          isDeleted: false,
        },
        select: notificationDataSelect,
        orderBy: { createdAt: 'desc' },
        take: maxFetchLimit,
      });

      // Build groups using a Map
      const groupMap: NotificationGroupMap = new Map();

      for (const notification of notifications) {
        const entityId = extractEntityIdFromMetadata(
          notification.metadata as Record<string, unknown>,
          notification.entityType,
        );

        const groupKey = generateGroupKey(
          notification.type.type,
          notification.entityType,
          entityId,
          notification.createdAt,
          groupByTime,
        );

        if (!groupMap.has(groupKey)) {
          groupMap.set(groupKey, {
            notifications: [],
            senderMap: new Map(),
            latestNotification: notification,
            allRead: true,
          });
        }

        const group = groupMap.get(groupKey)!;
        group.notifications.push(notification);

        // Track if all notifications in group are read
        if (!notification.isRead) {
          group.allRead = false;
        }

        // Update latest notification if this one is newer
        if (notification.createdAt > group.latestNotification.createdAt) {
          group.latestNotification = notification;
        }

        // Add sender to map (deduplication)
        const sender = this.buildSenderSummary(notification);
        if (sender && !group.senderMap.has(sender.id)) {
          group.senderMap.set(sender.id, sender);
        }
      }

      // Convert groups to array and sort by latest notification date
      const groupedNotifications: IGroupedNotification[] = [];

      for (const [groupKey, group] of groupMap) {
        const senders = Array.from(group.senderMap.values()).slice(0, 3);
        const latest = group.latestNotification;
        const entityId = extractEntityIdFromMetadata(
          latest.metadata as Record<string, unknown>,
          latest.entityType,
        );

        // Build grouped message content
        const actionText = getActionTextByType(latest.type.type);
        const groupedMessage = this.buildGroupedMessageFromSenders(
          senders,
          group.notifications.length,
          actionText,
        );

        const content = latest.content as { title: string; message: string };

        groupedNotifications.push({
          groupKey,
          type: {
            id: latest.type.id,
            type: latest.type.type,
          },
          entityType: latest.entityType,
          entityId,
          count: group.notifications.length,
          senders,
          content: {
            title: content?.title ?? 'Notification',
            message: groupedMessage,
          },
          metadata: latest.metadata as Record<string, unknown>,
          priority: latest.priority,
          createdAt: latest.createdAt,
          isRead: group.allRead,
          notificationIds: group.notifications.map((n) => n.id),
        });
      }

      // Sort by createdAt descending
      groupedNotifications.sort(
        (a, b) => b.createdAt.getTime() - a.createdAt.getTime(),
      );

      // Paginate groups
      const totalCount = groupedNotifications.length;
      const startIndex = (page - 1) * limit;
      const paginatedGroups = groupedNotifications.slice(
        startIndex,
        startIndex + limit,
      );

      const totalPage = Math.ceil(totalCount / limit);
      const hasNextPage = page * limit < totalCount;
      const hasPreviousPage = !!totalCount && page > 1;

      return {
        message: 'Grouped notifications fetched successfully',
        data: {
          currentPage: page,
          items: paginatedGroups,
          totalCount,
          totalPage,
          pageSize: limit,
          hasNextPage,
          hasPreviousPage,
        },
        statusCode: 200,
        date: new Date(),
      };
    } catch (error) {
      handleDefaultError(error);
    }
  }

  /**
   * Build grouped message from senders
   */
  private buildGroupedMessageFromSenders(
    senders: ISenderSummary[],
    count: number,
    actionText: string,
  ): string {
    // Guard clause: if no senders (e.g., system notifications), return generic message
    if (!senders || senders.length === 0) {
      return `${count} notifications ${actionText}`;
    }

    if (count === 1) {
      return `${senders[0].fullName} ${actionText}`;
    }

    if (count === 2 && senders.length >= 2) {
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
   * Mark multiple notifications as read (for groups)
   */
  async markNotificationsAsRead(
    notificationIds: string[],
    isRead: boolean,
  ): Promise<IResponseType<null>> {
    try {
      await this.prisma.notification.updateMany({
        where: { id: { in: notificationIds } },
        data: { isRead, readAt: isRead ? new Date() : null },
      });

      return {
        message: 'Notifications status updated successfully',
        data: null,
        statusCode: 200,
        date: new Date(),
      };
    } catch (error) {
      handleDefaultError(error);
    }
  }
}
