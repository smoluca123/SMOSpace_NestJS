import { Injectable } from '@nestjs/common';
import { EntityType, NotificationPriority, Prisma } from '@prisma/client';
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
  INotificationReplyCommentPayload,
} from 'src/resources/notification/notification.interfaces';

@Injectable()
export class NotificationService {
  constructor(
    private readonly prisma: PrismaService,
    private readonly notificationGateway: NotificationGateway,
  ) {}

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
        data: {
          isDeleted: true,
        },
      });
    } catch (error) {
      handleDefaultError(error);
    }
  }

  async deleteNotifications(ids: string[]) {
    try {
      return await this.prisma.notification.updateMany({
        where: { id: { in: ids } },
        data: {
          isDeleted: true,
        },
      });
    } catch (error) {
      handleDefaultError(error);
    }
  }

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
              in: ['COMMENT_POST', 'REPLY_COMMENT', 'COMMENT_MENTION'],
            },
          },
          ...(postId && {
            AND: [
              {
                metadata: {
                  path: ['postId'],
                  equals: postId,
                },
              },
              {
                metadata: {
                  path: ['commentId'],
                  equals: commentId,
                },
              },
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

  async createFollowNotification(payload: INotificationFollowPayload) {
    // const follower = await this.prisma.follow.findUnique({
    //   where: {
    //     followerId_followingId: {
    //       followerId: payload.senderId,
    //       followingId: payload.recipientId,
    //     },
    //   },
    //   select: {
    //     id: true,
    //     follower: {
    //       select: {
    //         username: true,
    //         fullName: true,
    //         avatar: true,
    //       },
    //     },
    //   },
    // });
    // if (!follower) return;

    const message = this.formatMessage(
      NOTIFICATION_MESSAGES.FOLLOW_USER.message,
      { username: payload.senderData.username },
    );

    const newNotificationData: Prisma.NotificationCreateInput = {
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
      type: {
        connectOrCreate: {
          where: {
            type: 'FOLLOW_USER',
          },
          create: {
            type: 'FOLLOW_USER',
          },
        },
      },
      createdAt: new Date(),
      sender: {
        connect: { id: payload.senderId },
      },
      recipient: {
        connect: { id: payload.recipientId },
      },
    };

    const existingNotification = await this.prisma.notification.findFirst({
      where: {
        recipientId: payload.recipientId,
        senderId: payload.senderId,
        type: {
          type: 'FOLLOW_USER',
        },
      },
    });
    if (existingNotification) {
      return this.prisma.notification.update({
        where: { id: existingNotification.id },
        data: newNotificationData,
      });
    }

    const newNotification = await this.prisma.notification.create({
      data: newNotificationData,
      select: notificationDataSelect,
    });

    this.notificationGateway.emitNewNotification(newNotification);
    return newNotification;
  }

  async deleteFollowNotification(payload: {
    recipientId: string;
    senderId: string;
  }) {
    try {
      await this.prisma.notification.deleteMany({
        where: {
          recipientId: payload.recipientId,
          senderId: payload.senderId,
          type: { type: 'FOLLOW_USER' },
        },
      });
    } catch (error) {
      handleDefaultError(error);
    }
  }

  async createCommentNotification(payload: INotificationCommentPayload) {
    try {
      if (payload.senderId === payload.recipientId) return;

      const message = this.formatMessage(
        NOTIFICATION_MESSAGES.COMMENT_POST.message,
        { username: payload.senderData.username },
      );
      const newNotificationData: Prisma.NotificationCreateInput = {
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

        type: {
          connectOrCreate: {
            where: {
              type: 'COMMENT_POST',
            },
            create: {
              type: 'COMMENT_POST',
            },
          },
        },
        sender: {
          connect: { id: payload.senderId },
        },
        recipient: {
          connect: { id: payload.recipientId },
        },
      };

      const newNotification = await this.prisma.notification.create({
        data: newNotificationData,
        select: notificationDataSelect,
      });
      this.notificationGateway.emitNewNotification(newNotification);
      return newNotification;
    } catch (error) {
      handleDefaultError(error);
    }
  }

  async createFriendRequestNotification(
    payload: INotificationFriendRequestPayload,
  ) {
    try {
      const message = this.formatMessage(
        NOTIFICATION_MESSAGES.FRIEND_REQUEST.message,
        { username: payload.senderData.username },
      );

      const newNotificationData: Prisma.NotificationCreateInput = {
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
        type: {
          connectOrCreate: {
            where: {
              type: 'FRIEND_REQUEST',
            },
            create: {
              type: 'FRIEND_REQUEST',
            },
          },
        },
        createdAt: new Date(),
        sender: {
          connect: { id: payload.senderId },
        },
        recipient: {
          connect: { id: payload.recipientId },
        },
      };

      const existingNotification = await this.prisma.notification.findFirst({
        where: {
          recipientId: payload.recipientId,
          senderId: payload.senderId,
          type: {
            type: 'FRIEND_REQUEST',
          },
        },
      });
      if (existingNotification) {
        return this.prisma.notification.update({
          where: { id: existingNotification.id },
          data: newNotificationData,
        });
      }

      const newNotification = await this.prisma.notification.create({
        data: newNotificationData,
        select: notificationDataSelect,
      });

      this.notificationGateway.emitNewNotification(newNotification);
    } catch (error) {
      handleDefaultError(error);
    }
  }

  async createReplyCommentNotification(
    payload: INotificationReplyCommentPayload,
  ) {
    try {
      if (payload.senderId === payload.recipientId) return;

      const message = this.formatMessage(
        NOTIFICATION_MESSAGES.REPLY_COMMENT.message,
        { username: payload.senderData.username },
      );
      const newNotificationData: Prisma.NotificationCreateInput = {
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

        type: {
          connectOrCreate: {
            where: {
              type: 'REPLY_COMMENT',
            },
            create: {
              type: 'REPLY_COMMENT',
            },
          },
        },
        sender: {
          connect: { id: payload.senderId },
        },
        recipient: {
          connect: { id: payload.recipientId },
        },
      };

      const newNotification = await this.prisma.notification.create({
        data: newNotificationData,
        select: notificationDataSelect,
      });
      this.notificationGateway.emitNewNotification(newNotification);
      return newNotification;
    } catch (error) {
      handleDefaultError(error);
    }
  }

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
          orderBy: {
            createdAt: 'desc',
          },
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

  async deletePostRelatedNotifications(
    postId: string,
  ): Promise<IResponseType<null>> {
    try {
      // Delete all notifications that have this postId in their metadata
      await this.prisma.notification.deleteMany({
        where: {
          metadata: {
            path: ['postId'],
            equals: postId,
          },
          // type: {
          //   type: {
          //     in: [
          //       'COMMENT_POST',
          //       'REPLY_COMMENT',
          //       'LIKE_POST',
          //       'COMMENT_MENTION',

          //     ],
          //   },
          // },
        },
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

  async deleteFriendRequestNotifications({
    userId,
    friendId,
  }: {
    userId: string;
    friendId: string;
  }): Promise<IResponseType<null>> {
    try {
      // Delete all notifications that have this postId in their metadata
      await this.prisma.notification.deleteMany({
        where: {
          senderId: userId,
          recipientId: friendId,
          metadata: {
            path: ['friend', 'id'],
            equals: friendId,
          },
          type: {
            type: {
              in: ['FRIEND_REQUEST'],
            },
          },
        },
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
}
