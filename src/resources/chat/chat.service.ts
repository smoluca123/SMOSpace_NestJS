import { BadRequestException, Injectable } from '@nestjs/common';
import { PrismaService } from '../../prisma/prisma.service';
import { CreateMessageDto } from './dto/create-message.dto';
import { ChatRoom, ChatRole, ChatRoomStatus, Prisma } from '@prisma/client';
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

@Injectable()
export class ChatService {
  constructor(private prisma: PrismaService) {}

  async getUserActiveRooms({
    userId,
    limit = 10,
    page = 1,
  }: {
    userId: string;
    limit?: number;
    page?: number;
  }): Promise<IBeforeTransformPaginationResponseType<ChatRoomDataType>> {
    const whereQuery: Prisma.ChatRoomWhereInput = {
      status: ChatRoomStatus.APPROVED,
      participants: {
        some: {
          userId,
          leftAt: null,
        },
      },
    };

    const rooms = await this.prisma.chatRoom.findMany({
      where: whereQuery,
      take: limit,
      skip: (page - 1) * limit,
      select: chatRoomDataSelect,
    });

    return {
      type: 'pagination',
      message: 'User active rooms',
      data: {
        items: rooms,
        totalCount: await this.prisma.chatRoom.count(),
        currentPage: page,
        pageSize: limit,
      },
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

    return message;
  }

  async getRoomParticipants({
    roomId,
    limit = 10,
    page = 1,
  }: {
    roomId: string;
    limit?: number;
    page?: number;
  }): Promise<IBeforeTransformPaginationResponseType<ChatParticipantDataType>> {
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
      return existingRoom;
    }

    // Create new direct chat room
    return this.prisma.chatRoom.create({
      data: {
        type: 'DIRECT',
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
    return this.prisma.chatRoom.create({
      data: {
        name,
        type: 'GROUP',
        participants: {
          create: [
            { userId: creatorId, role: ChatRole.ADMIN },
            ...participantIds.map((userId) => ({
              userId,
              role: ChatRole.MEMBER,
            })),
          ],
        },
      },
    });
  }

  async getRoomMessages({
    roomId,
    limit,
    page,
    before,
  }: {
    roomId: string;
    limit: number;
    page: number;
    before?: Date;
  }): Promise<IBeforeTransformPaginationResponseType<ChatMessageDataType>> {
    const whereQuery: Prisma.ChatMessageWhereInput = {
      roomId,
      ...(before && {
        createdAt: { lt: before },
      }),
    };

    const messages = await this.prisma.chatMessage.findMany({
      where: whereQuery,
      orderBy: {
        createdAt: 'asc',
      },
      take: limit,
      skip: (page - 1) * limit,
      // include: {
      //   sender: {
      //     select: {
      //       id: true,
      //       username: true,
      //       displayName: true,
      //       avatar: true,
      //     },
      //   },
      //   replyTo: {
      //     include: {
      //       sender: {
      //         select: {
      //           id: true,
      //           username: true,
      //           displayName: true,
      //           avatar: true,
      //         },
      //       },
      //     },
      //   },
      // },
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
