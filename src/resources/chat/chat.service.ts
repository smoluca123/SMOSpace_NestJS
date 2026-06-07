import { BadRequestException, Injectable } from '@nestjs/common';
import { PrismaService } from '../../prisma/prisma.service';
import { CreateMessageDto } from './dto/create-message.dto';
import {
  ChatRoom,
  ChatRole,
  ChatRoomStatus,
  FriendStatus,
  MessageType,
  Prisma,
} from '@prisma/client';
import {
  IBeforeTransformPaginationResponseType,
  IBeforeTransformResponseType,
} from 'src/interfaces/interfaces.global';
import {
  chatMessageDataSelect,
  ChatMessageDataType,
  chatParticipantDataSelect,
  ChatParticipantDataType,
  chatRoomDataSelect,
  ChatRoomDataType,
} from 'src/libs/prisma-types';
import { S3Service } from 'src/services/aws/s3/s3.service';

@Injectable()
export class ChatService {
  constructor(
    private prisma: PrismaService,
    private readonly s3Service: S3Service,
  ) {}

  async getUserActiveRooms({
    userId,
    limit = 10,
    page = 1,
  }: {
    userId: string;
    limit?: number;
    page?: number;
  }): Promise<
    IBeforeTransformPaginationResponseType<
      ChatRoomDataType & { unreadCount: number }
    >
  > {
    const whereQuery: Prisma.ChatRoomWhereInput = {
      participants: {
        some: {
          userId,
          leftAt: null,
        },
      },
      OR: [
        { status: ChatRoomStatus.APPROVED },
        // Pending rooms I initiated (I already sent a message) still show for me
        {
          status: ChatRoomStatus.PENDING,
          messages: { some: { senderId: userId } },
        },
      ],
    };

    const [totalCount, rooms] = await this.prisma.$transaction([
      this.prisma.chatRoom.count({ where: whereQuery }),
      this.prisma.chatRoom.findMany({
        where: whereQuery,
        take: limit,
        skip: (page - 1) * limit,
        orderBy: { updatedAt: 'desc' },
        select: chatRoomDataSelect,
      }),
    ]);

    const roomsWithUnread = await this.attachUnreadCounts(rooms, userId);

    return {
      type: 'pagination',
      message: 'User active rooms',
      data: {
        items: roomsWithUnread,
        totalCount,
        currentPage: page,
        pageSize: limit,
      },
    };
  }

  /**
   * Attach the per-room unread count (messages not sent by the user and not yet
   * read by them) using a single grouped query instead of one query per room.
   */
  private async attachUnreadCounts<T extends { id: string }>(
    rooms: T[],
    userId: string,
  ): Promise<(T & { unreadCount: number })[]> {
    if (rooms.length === 0) return [];

    const unreadGroups = await this.prisma.chatMessage.groupBy({
      by: ['roomId'],
      where: {
        roomId: { in: rooms.map((room) => room.id) },
        senderId: { not: userId },
        NOT: { readBy: { has: userId } },
      },
      _count: { _all: true },
    });

    const unreadByRoom = new Map(
      unreadGroups.map((group) => [group.roomId, group._count._all]),
    );

    return rooms.map((room) => ({
      ...room,
      unreadCount: unreadByRoom.get(room.id) ?? 0,
    }));
  }

  /**
   * Pending message requests for a user: PENDING direct rooms started by someone
   * else (the user hasn't sent any message in them yet).
   */
  private messageRequestWhere(userId: string): Prisma.ChatRoomWhereInput {
    return {
      status: ChatRoomStatus.PENDING,
      participants: { some: { userId, leftAt: null } },
      AND: [
        { messages: { some: {} } }, // has at least one message
        { messages: { none: { senderId: userId } } }, // none sent by me
      ],
    };
  }

  async getMessageRequests({
    userId,
    limit = 20,
    page = 1,
  }: {
    userId: string;
    limit?: number;
    page?: number;
  }): Promise<IBeforeTransformPaginationResponseType<ChatRoomDataType>> {
    const whereQuery = this.messageRequestWhere(userId);

    const [totalCount, rooms] = await this.prisma.$transaction([
      this.prisma.chatRoom.count({ where: whereQuery }),
      this.prisma.chatRoom.findMany({
        where: whereQuery,
        take: limit,
        skip: (page - 1) * limit,
        orderBy: { updatedAt: 'desc' },
        select: chatRoomDataSelect,
      }),
    ]);

    return {
      type: 'pagination',
      message: 'Message requests',
      data: {
        items: rooms,
        totalCount,
        currentPage: page,
        pageSize: limit,
      },
    };
  }

  async getMessageRequestCount(
    userId: string,
  ): Promise<IBeforeTransformResponseType<{ count: number }>> {
    const count = await this.prisma.chatRoom.count({
      where: this.messageRequestWhere(userId),
    });

    return {
      type: 'response',
      message: 'Message request count',
      data: { count },
    };
  }

  /**
   * Ensure the user is an active participant of the room, returning the
   * participant id. Throws when they are not, so callers don't act on rooms
   * they don't belong to.
   */
  private async ensureParticipant(
    userId: string,
    roomId: string,
  ): Promise<string> {
    const participant = await this.prisma.chatParticipant.findFirst({
      where: { userId, roomId, leftAt: null },
      select: { id: true },
    });

    if (!participant) {
      throw new BadRequestException('You are not a participant in this room');
    }

    return participant.id;
  }

  async acceptMessageRequest(
    userId: string,
    roomId: string,
  ): Promise<IBeforeTransformResponseType<ChatRoom>> {
    await this.ensureParticipant(userId, roomId);

    const room = await this.prisma.chatRoom.update({
      where: { id: roomId },
      data: { status: ChatRoomStatus.APPROVED },
    });

    return {
      type: 'response',
      message: 'Message request accepted',
      data: room,
    };
  }

  async rejectMessageRequest(
    userId: string,
    roomId: string,
  ): Promise<IBeforeTransformResponseType<{ success: boolean }>> {
    await this.ensureParticipant(userId, roomId);

    await this.prisma.chatRoom.update({
      where: { id: roomId },
      data: { status: ChatRoomStatus.REJECTED },
    });

    return {
      type: 'response',
      message: 'Message request rejected',
      data: { success: true },
    };
  }

  /**
   * Total number of unread messages across all the user's rooms (header badge).
   */
  async getUnreadCount(
    userId: string,
  ): Promise<IBeforeTransformResponseType<{ count: number }>> {
    const count = await this.prisma.chatMessage.count({
      where: {
        senderId: { not: userId },
        NOT: { readBy: { has: userId } },
        room: {
          status: ChatRoomStatus.APPROVED,
          participants: { some: { userId, leftAt: null } },
        },
      },
    });

    return {
      type: 'response',
      message: 'Unread message count',
      data: { count },
    };
  }

  /**
   * Mark every message in a room as read for the given user.
   */
  async markRoomAsRead(
    userId: string,
    roomId: string,
  ): Promise<IBeforeTransformResponseType<{ success: boolean }>> {
    await this.prisma.chatMessage.updateMany({
      where: {
        roomId,
        senderId: { not: userId },
        NOT: { readBy: { has: userId } },
      },
      data: {
        readBy: { push: userId },
      },
    });

    return {
      type: 'response',
      message: 'Room marked as read',
      data: { success: true },
    };
  }

  /**
   * Mark a room as unread for the user by removing them from the readBy list
   * of the latest message they didn't send.
   */
  async markRoomAsUnread(
    userId: string,
    roomId: string,
  ): Promise<IBeforeTransformResponseType<{ success: boolean }>> {
    const latestMessage = await this.prisma.chatMessage.findFirst({
      where: {
        roomId,
        senderId: { not: userId },
      },
      orderBy: { createdAt: 'desc' },
      select: { id: true, readBy: true },
    });

    if (latestMessage) {
      await this.prisma.chatMessage.update({
        where: { id: latestMessage.id },
        data: {
          readBy: latestMessage.readBy.filter((id) => id !== userId),
        },
      });
    }

    return {
      type: 'response',
      message: 'Room marked as unread',
      data: { success: true },
    };
  }

  /**
   * Toggle notification mute state for the user in a room.
   */
  async toggleMuteRoom(
    userId: string,
    roomId: string,
  ): Promise<IBeforeTransformResponseType<{ isMuted: boolean }>> {
    const participant = await this.prisma.chatParticipant.findFirst({
      where: { userId, roomId },
      select: { id: true, isMuted: true },
    });

    if (!participant) {
      throw new BadRequestException('You are not a participant in this room');
    }

    const updated = await this.prisma.chatParticipant.update({
      where: { id: participant.id },
      data: { isMuted: !participant.isMuted },
      select: { isMuted: true },
    });

    return {
      type: 'response',
      message: updated.isMuted ? 'Room muted' : 'Room unmuted',
      data: { isMuted: updated.isMuted },
    };
  }

  /**
   * "Delete" a conversation for the user by leaving the room (soft, per-user).
   */
  async deleteConversation(
    userId: string,
    roomId: string,
  ): Promise<IBeforeTransformResponseType<{ success: boolean }>> {
    await this.prisma.chatParticipant.updateMany({
      where: { userId, roomId },
      data: { leftAt: new Date() },
    });

    return {
      type: 'response',
      message: 'Conversation deleted',
      data: { success: true },
    };
  }

  async canUserJoinRoom(userId: string, roomId: string): Promise<boolean> {
    const participant = await this.prisma.chatParticipant.findFirst({
      where: {
        userId,
        roomId,
        leftAt: null,
      },
    });
    return !!participant;
  }

  async handleCreateMessage(
    userId: string,
    createMessageDto: CreateMessageDto,
  ): Promise<ChatMessageDataType> {
    const { roomId, content, type, replyToId } = createMessageDto;

    // Verify user is a participant
    const participant = await this.prisma.chatParticipant.findFirst({
      where: {
        userId,
        roomId,
        leftAt: null,
      },
    });

    if (!participant) {
      throw new BadRequestException('User is not a participant in this room');
    }

    // If this is a reply, verify the original message exists
    if (replyToId) {
      const originalMessage = await this.prisma.chatMessage.findFirst({
        where: {
          id: replyToId,
          roomId,
        },
      });

      if (!originalMessage) {
        throw new BadRequestException('Original message not found');
      }
    }

    // Create message
    const message = await this.prisma.chatMessage.create({
      data: {
        roomId,
        senderId: userId,
        content,
        type,
        replyToId,

        readBy: [userId], // Mark as read by sender
      },
      //   include: {
      //     sender: {
      //       select: {
      //         id: true,
      //         username: true,
      //         displayName: true,
      //         avatar: true,
      //       },
      //     },
      //     replyTo: {
      //       include: {
      //         sender: {
      //           select: {
      //             id: true,
      //             username: true,
      //             displayName: true,
      //             avatar: true,
      //           },
      //         },
      //       },
      //     },
      //   },
      select: chatMessageDataSelect,
    });

    // Keep the room's lastMessage pointer + updatedAt in sync
    await this.prisma.chatRoom.update({
      where: { id: roomId },
      data: { lastMessageId: message.id },
    });

    return message;
  }

  async getRoomParticipants({
    userId,
    roomId,
    limit = 10,
    page = 1,
  }: {
    userId: string;
    roomId: string;
    limit?: number;
    page?: number;
  }): Promise<IBeforeTransformPaginationResponseType<ChatParticipantDataType>> {
    // Only members of the room may view its participants
    await this.ensureParticipant(userId, roomId);

    const whereQuery: Prisma.ChatParticipantWhereInput = {
      roomId,
      leftAt: null,
    };
    const [totalCount, participants] = await this.prisma.$transaction([
      this.prisma.chatParticipant.count({
        where: whereQuery,
      }),
      this.prisma.chatParticipant.findMany({
        where: whereQuery,
        select: chatParticipantDataSelect,
        take: limit,
        skip: (page - 1) * limit,
      }),
    ]);
    return {
      type: 'pagination',
      message: 'Room participants',
      data: {
        items: participants,
        totalCount,
        currentPage: page,
        pageSize: limit,
      },
    };
  }

  async markMessagesAsRead(
    userId: string,
    messageIds: string[],
  ): Promise<void> {
    await this.prisma.chatMessage.updateMany({
      where: {
        id: {
          in: messageIds,
        },
        NOT: {
          readBy: {
            has: userId,
          },
        },
      },
      data: {
        readBy: {
          push: userId,
        },
      },
    });
  }

  async handleCreateDirectChatRoom({
    userId1,
    userId2,
  }: {
    userId1: string;
    userId2: string;
  }): Promise<ChatRoom> {
    // Prevent starting a direct conversation when either user has blocked the
    // other (block works in both directions).
    const blockRelationship = await this.prisma.friend.findFirst({
      where: {
        status: FriendStatus.BLOCKED,
        OR: [
          { userId: userId1, friendId: userId2 },
          { userId: userId2, friendId: userId1 },
        ],
      },
      select: { id: true },
    });

    if (blockRelationship) {
      throw new BadRequestException(
        'Cannot start a conversation with a blocked user',
      );
    }

    // Check if direct chat already exists
    const existingRoom = await this.prisma.chatRoom.findFirst({
      where: {
        type: 'DIRECT',
        participants: {
          every: {
            userId: {
              in: [userId1, userId2],
            },
          },
        },
      },
    });

    if (existingRoom) {
      // Re-activate participants who previously "deleted" (left) the conversation
      await this.prisma.chatParticipant.updateMany({
        where: { roomId: existingRoom.id, leftAt: { not: null } },
        data: { leftAt: null },
      });

      // A previously rejected request becomes a new pending request again
      if (existingRoom.status === ChatRoomStatus.REJECTED) {
        return this.prisma.chatRoom.update({
          where: { id: existingRoom.id },
          data: { status: ChatRoomStatus.PENDING },
        });
      }
      return existingRoom;
    }

    // Friends can message freely (auto-approved); strangers go to message requests
    const areFriends = await this.prisma.friend.findFirst({
      where: {
        status: FriendStatus.ACCEPTED,
        OR: [
          { userId: userId1, friendId: userId2 },
          { userId: userId2, friendId: userId1 },
        ],
      },
      select: { id: true },
    });

    return this.prisma.chatRoom.create({
      data: {
        type: 'DIRECT',
        status: areFriends ? ChatRoomStatus.APPROVED : ChatRoomStatus.PENDING,
        participants: {
          create: [{ userId: userId1 }, { userId: userId2 }],
        },
      },
    });
  }

  async handleCreateGroupChatRoom(
    name: string,
    creatorId: string,
    participantIds: string[],
  ): Promise<ChatRoom> {
    // Exclude the creator from the member list to avoid duplicates
    const memberIds = [...new Set(participantIds)].filter(
      (id) => id !== creatorId,
    );

    if (memberIds.length === 0) {
      throw new BadRequestException('A group needs at least one other member');
    }

    return this.prisma.chatRoom.create({
      data: {
        name,
        type: 'GROUP',
        status: ChatRoomStatus.APPROVED,
        participants: {
          create: [
            { userId: creatorId, role: ChatRole.ADMIN },
            ...memberIds.map((userId) => ({
              userId,
              role: ChatRole.MEMBER,
            })),
          ],
        },
      },
    });
  }

  /**
   * Upload an image and create an IMAGE message in the room.
   */
  async handleCreateImageMessage(
    userId: string,
    roomId: string,
    file: Express.Multer.File,
  ): Promise<ChatMessageDataType> {
    if (!file) {
      throw new BadRequestException('Image file is required');
    }

    const { url } = await this.s3Service.uploadImage({
      file,
      name: file.originalname,
      userId,
    });

    return this.handleCreateMessage(userId, {
      roomId,
      content: url,
      type: MessageType.IMAGE,
    });
  }

  async getRoomMessages({
    userId,
    roomId,
    limit,
    page,
    before,
  }: {
    userId: string;
    roomId: string;
    limit: number;
    page: number;
    before?: Date;
  }): Promise<IBeforeTransformPaginationResponseType<ChatMessageDataType>> {
    // Only members of the room may read its messages
    await this.ensureParticipant(userId, roomId);

    const whereQuery: Prisma.ChatMessageWhereInput = {
      roomId,
      ...(before && {
        createdAt: { lt: before },
      }),
    };

    const messages = await this.prisma.chatMessage.findMany({
      where: whereQuery,
      orderBy: {
        createdAt: 'desc',
      },
      take: limit,
      skip: (page - 1) * limit,
      select: chatMessageDataSelect,
    });
    return {
      type: 'pagination',
      message: 'Room messages',
      data: {
        items: messages,
        totalCount: await this.prisma.chatMessage.count({
          where: whereQuery,
        }),
        currentPage: page,
        pageSize: limit,
      },
    };
  }

  async approveChatRoom({
    roomId,
    approverId,
  }: {
    roomId: string;
    approverId: string;
  }): Promise<IBeforeTransformResponseType<ChatRoomDataType>> {
    // Verify the approver is a participant in the room
    const room = await this.prisma.chatRoom.findUnique({
      where: {
        id: roomId,
        participants: { some: { userId: approverId, leftAt: null } },
      },
      select: chatRoomDataSelect,
    });

    if (!room) {
      throw new Error('Room not found');
    }

    // Update message status
    return {
      type: 'response',
      message: 'Chat room approved',
      data: room,
    };
  }

  async rejectChatRoom({
    roomId,
    rejecterId,
  }: {
    roomId: string;
    rejecterId: string;
  }): Promise<IBeforeTransformResponseType<ChatRoomDataType>> {
    // Similar to approveMessage but sets status to REJECTED
    const room = await this.prisma.chatRoom.findUnique({
      where: {
        id: roomId,
        participants: { some: { userId: rejecterId, leftAt: null } },
      },
      select: chatRoomDataSelect,
    });

    if (!room) {
      throw new Error('Room not found');
    }

    return {
      type: 'response',
      message: 'Chat room rejected',
      data: room,
    };
  }

  async getPendingChatRooms({
    limit = 10,
    page = 1,
  }: {
    limit?: number;
    page?: number;
  }): Promise<IBeforeTransformPaginationResponseType<ChatRoomDataType>> {
    const whereQuery: Prisma.ChatRoomWhereInput = {
      status: ChatRoomStatus.PENDING,
    };

    const [totalCount, rooms] = await this.prisma.$transaction([
      this.prisma.chatRoom.count({
        where: whereQuery,
      }),
      this.prisma.chatRoom.findMany({
        where: whereQuery,
        select: chatRoomDataSelect,
      }),
    ]);

    return {
      type: 'pagination',
      message: 'Pending chat rooms',
      data: {
        items: rooms,
        totalCount,
        currentPage: page,
        pageSize: limit,
      },
    };
  }
}
