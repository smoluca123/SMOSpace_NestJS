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
  ReactionType,
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

  /**
   * Candidate recipients for sharing a post into a direct chat: people the
   * user can reasonably message - friends, people they follow, and anyone they
   * already have a direct conversation with. Blocked users (either direction)
   * are excluded. Supports an optional name/username search.
   */
  async getShareRecipients({
    userId,
    search,
    limit = 20,
    page = 1,
  }: {
    userId: string;
    search?: string;
    limit?: number;
    page?: number;
  }): Promise<
    IBeforeTransformPaginationResponseType<{
      id: string;
      username: string;
      fullName: string;
      avatar: string | null;
    }>
  > {
    // 1) Friends (accepted, either direction)
    const friendRows = await this.prisma.friend.findMany({
      where: {
        status: FriendStatus.ACCEPTED,
        OR: [{ userId }, { friendId: userId }],
      },
      select: { userId: true, friendId: true },
    });

    // 2) People the user follows
    const followRows = await this.prisma.follow.findMany({
      where: { followerId: userId },
      select: { followingId: true },
    });

    // 3) Existing direct-chat partners
    const directRooms = await this.prisma.chatRoom.findMany({
      where: {
        type: 'DIRECT',
        participants: { some: { userId, leftAt: null } },
      },
      select: { participants: { select: { userId: true } } },
    });

    // 4) Blocked users (either direction) - excluded
    const blockedRows = await this.prisma.friend.findMany({
      where: {
        status: FriendStatus.BLOCKED,
        OR: [{ userId }, { friendId: userId }],
      },
      select: { userId: true, friendId: true },
    });

    const candidateIds = new Set<string>();
    friendRows.forEach((row) => {
      candidateIds.add(row.userId === userId ? row.friendId : row.userId);
    });
    followRows.forEach((row) => candidateIds.add(row.followingId));
    directRooms.forEach((room) =>
      room.participants.forEach((p) => {
        if (p.userId && p.userId !== userId) candidateIds.add(p.userId);
      }),
    );

    // Remove self + blocked
    candidateIds.delete(userId);
    blockedRows.forEach((row) => {
      candidateIds.delete(row.userId === userId ? row.friendId : row.userId);
    });

    const ids = [...candidateIds];

    if (ids.length === 0) {
      return {
        type: 'pagination',
        message: 'Share recipients',
        data: { items: [], totalCount: 0, currentPage: page, pageSize: limit },
      };
    }

    const whereQuery: Prisma.UserWhereInput = {
      id: { in: ids },
      ...(search
        ? {
            OR: [
              { fullName: { contains: search, mode: 'insensitive' } },
              { username: { contains: search, mode: 'insensitive' } },
            ],
          }
        : {}),
    };

    const [totalCount, users] = await this.prisma.$transaction([
      this.prisma.user.count({ where: whereQuery }),
      this.prisma.user.findMany({
        where: whereQuery,
        take: limit,
        skip: (page - 1) * limit,
        orderBy: { fullName: 'asc' },
        select: { id: true, username: true, fullName: true, avatar: true },
      }),
    ]);

    return {
      type: 'pagination',
      message: 'Share recipients',
      data: { items: users, totalCount, currentPage: page, pageSize: limit },
    };
  }

  /**
   * Block enforcement for direct conversations: if the sender and the other
   * participant have a BLOCKED relationship (in either direction), messaging is
   * not allowed. Group rooms are unaffected. Throws BadRequestException when the
   * message must be rejected.
   */
  private async assertNotBlockedInDirectRoom(
    senderId: string,
    roomId: string,
  ): Promise<void> {
    const room = await this.prisma.chatRoom.findUnique({
      where: { id: roomId },
      select: {
        type: true,
        participants: { select: { userId: true } },
      },
    });

    if (!room || room.type !== 'DIRECT') return;

    const otherId = room.participants.find(
      (p) => p.userId && p.userId !== senderId,
    )?.userId;

    if (!otherId) return;

    const blockRelationship = await this.prisma.friend.findFirst({
      where: {
        status: FriendStatus.BLOCKED,
        OR: [
          { userId: senderId, friendId: otherId },
          { userId: otherId, friendId: senderId },
        ],
      },
      select: { id: true },
    });

    if (blockRelationship) {
      throw new BadRequestException('Cannot send a message to a blocked user');
    }
  }

  async handleCreateMessage(
    userId: string,
    createMessageDto: CreateMessageDto,
  ): Promise<ChatMessageDataType> {
    const { roomId, content, type, replyToId, isForwarded } = createMessageDto;

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

    // For direct conversations, block (in either direction) prevents messaging.
    await this.assertNotBlockedInDirectRoom(userId, roomId);

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
        isForwarded: isForwarded ?? false,

        readBy: [userId], // Mark as read by sender
      },
      select: chatMessageDataSelect,
    });

    // Keep the room's lastMessage pointer + updatedAt in sync
    await this.prisma.chatRoom.update({
      where: { id: roomId },
      data: { lastMessageId: message.id },
    });

    return message;
  }

  /**
   * Share a post into one or more chats.
   *
   * `roomIds` target existing rooms the user belongs to; `userIds` are resolved
   * to direct rooms (created/reused). A POST_SHARE message is created in each
   * room with the post id as its content. Returns every created message so the
   * caller (controller) can broadcast them over the socket.
   */
  async sharePostToChats({
    userId,
    postId,
    roomIds = [],
    userIds = [],
  }: {
    userId: string;
    postId: string;
    roomIds?: string[];
    userIds?: string[];
  }): Promise<IBeforeTransformResponseType<ChatMessageDataType[]>> {
    if (roomIds.length === 0 && userIds.length === 0) {
      throw new BadRequestException('Pick at least one recipient');
    }

    // Validate the post and its visibility.
    const post = await this.prisma.post.findUnique({
      where: { id: postId },
      select: { id: true, isPrivate: true, authorId: true },
    });

    if (!post) {
      throw new BadRequestException('Post not found');
    }

    if (post.isPrivate && post.authorId !== userId) {
      throw new BadRequestException('You cannot share a private post');
    }

    // Resolve direct rooms for each target user.
    const resolvedRoomIds = new Set<string>(roomIds);
    for (const targetUserId of userIds) {
      if (targetUserId === userId) continue;
      const room = await this.handleCreateDirectChatRoom({
        userId1: userId,
        userId2: targetUserId,
      });
      resolvedRoomIds.add(room.id);
    }

    const messages: ChatMessageDataType[] = [];
    for (const roomId of resolvedRoomIds) {
      const message = await this.handleCreateMessage(userId, {
        roomId,
        content: postId,
        type: MessageType.POST_SHARE,
      });
      messages.push(message);
    }

    return {
      type: 'response',
      message: 'Post shared to chats',
      data: messages,
    };
  }

  /**
   * Forward an existing message to one or more rooms. Copies the original's
   * content + type and flags the new messages as forwarded.
   */
  async forwardMessage({
    userId,
    messageId,
    roomIds,
  }: {
    userId: string;
    messageId: string;
    roomIds: string[];
  }): Promise<IBeforeTransformResponseType<ChatMessageDataType[]>> {
    if (!roomIds || roomIds.length === 0) {
      throw new BadRequestException('Pick at least one destination');
    }

    const original = await this.prisma.chatMessage.findUnique({
      where: { id: messageId },
      select: { id: true, roomId: true, content: true, type: true },
    });

    if (!original) {
      throw new BadRequestException('Message not found');
    }

    // The user must belong to the room the message came from.
    await this.ensureParticipant(userId, original.roomId);

    const messages: ChatMessageDataType[] = [];
    for (const roomId of [...new Set(roomIds)]) {
      const message = await this.handleCreateMessage(userId, {
        roomId,
        content: original.content,
        type: original.type,
        isForwarded: true,
      });
      messages.push(message);
    }

    return {
      type: 'response',
      message: 'Message forwarded',
      data: messages,
    };
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

  /**
   * Toggle a reaction on a chat message.
   *
   * - No existing reaction       -> create with `type`
   * - Existing reaction same     -> remove (toggle off)
   * - Existing reaction different -> update to new `type` (swap)
   *
   * Returns the updated message (with full reaction list) so callers can
   * broadcast/serve a fresh snapshot.
   */
  async reactToMessage({
    userId,
    messageId,
    type,
  }: {
    userId: string;
    messageId: string;
    type: ReactionType;
  }): Promise<
    IBeforeTransformResponseType<{
      message: ChatMessageDataType;
      myReaction: ReactionType | null;
    }>
  > {
    const message = await this.prisma.chatMessage.findUnique({
      where: { id: messageId },
      select: { id: true, roomId: true },
    });

    if (!message) {
      throw new BadRequestException('Message not found');
    }

    // Only members of the room may react
    await this.ensureParticipant(userId, message.roomId);

    const existing = await this.prisma.chatMessageReaction.findUnique({
      where: { userId_messageId: { userId, messageId } },
      select: { id: true, type: true },
    });

    let myReaction: ReactionType | null = type;

    if (!existing) {
      await this.prisma.chatMessageReaction.create({
        data: { userId, messageId, type },
      });
    } else if (existing.type === type) {
      await this.prisma.chatMessageReaction.delete({
        where: { id: existing.id },
      });
      myReaction = null;
    } else {
      await this.prisma.chatMessageReaction.update({
        where: { id: existing.id },
        data: { type },
      });
    }

    const updated = await this.prisma.chatMessage.findUniqueOrThrow({
      where: { id: messageId },
      select: chatMessageDataSelect,
    });

    return {
      type: 'response',
      message: 'Message reaction updated',
      data: { message: updated, myReaction },
    };
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

  /**
   * Upload a generic file attachment and create a FILE message. The message
   * `content` stores a JSON descriptor `{ url, name, size, mime }` so the
   * client can render a download card with the original metadata.
   */
  async handleCreateFileMessage(
    userId: string,
    roomId: string,
    file: Express.Multer.File,
  ): Promise<ChatMessageDataType> {
    if (!file) {
      throw new BadRequestException('File is required');
    }

    const { url } = await this.s3Service.uploadRawFile({
      file,
      name: file.originalname,
      userId,
    });

    const content = JSON.stringify({
      url,
      name: file.originalname,
      size: file.size,
      mime: file.mimetype,
    });

    return this.handleCreateMessage(userId, {
      roomId,
      content,
      type: MessageType.FILE,
    });
  }

  /**
   * Upload a voice note and create a VOICE message. The message `content`
   * stores a JSON descriptor `{ url, duration, size }` (duration in seconds).
   */
  async handleCreateVoiceMessage(
    userId: string,
    roomId: string,
    file: Express.Multer.File,
    duration?: number,
  ): Promise<ChatMessageDataType> {
    if (!file) {
      throw new BadRequestException('Audio file is required');
    }

    const { url } = await this.s3Service.uploadRawFile({
      file,
      name: file.originalname || `voice-${Date.now()}.webm`,
      userId,
    });

    const content = JSON.stringify({
      url,
      duration: duration ?? 0,
      size: file.size,
    });

    return this.handleCreateMessage(userId, {
      roomId,
      content,
      type: MessageType.VOICE,
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
        // Count ALL messages in the room (regardless of the `before` cursor) so
        // the client can determine hasNextPage correctly when paginating upward.
        totalCount: await this.prisma.chatMessage.count({
          where: { roomId },
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
