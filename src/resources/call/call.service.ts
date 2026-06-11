import { Injectable } from '@nestjs/common';
import { MessageType } from '@prisma/client';
import { PrismaService } from 'src/prisma/prisma.service';
import { IBeforeTransformPaginationResponseType } from 'src/interfaces/interfaces.global';

export type CallStatus = 'missed' | 'ended';
export type CallTypeEnum = 'audio' | 'video';

export interface CallRecord {
  messageId: string;
  roomId: string;
  roomName: string | null;
  callType: CallTypeEnum;
  status: CallStatus;
  /** Duration in seconds (0 for missed calls). */
  duration: number;
  createdAt: Date;
  /** The other participant(s) in the call. */
  participants: {
    id: string;
    username: string;
    fullName: string;
    avatar: string | null;
  }[];
}

interface GetCallHistoryParams {
  userId: string;
  page: number;
  limit: number;
  /** Optional filter: only 'audio', 'video', or 'missed' */
  filter?: 'audio' | 'video' | 'missed' | 'all';
}

@Injectable()
export class CallService {
  constructor(private readonly prisma: PrismaService) {}

  /**
   * Retrieve paginated call history for a user.
   * Records are SYSTEM messages containing a call JSON descriptor stored by
   * CallGateway.finalizeSession(). We filter to only rooms the user participates
   * in and parse the JSON payload to build structured CallRecord objects.
   */
  async getCallHistory({
    userId,
    page,
    limit,
    filter = 'all',
  }: GetCallHistoryParams): Promise<
    IBeforeTransformPaginationResponseType<CallRecord>
  > {
    const skip = (page - 1) * limit;

    // Build optional content filter for callType/status
    const contentFilters = this.buildContentFilters(filter);

    // Query SYSTEM messages from rooms the user is a member of
    const [messages, totalCount] = await Promise.all([
      this.prisma.chatMessage.findMany({
        where: {
          type: MessageType.SYSTEM,
          room: {
            participants: {
              some: { userId, leftAt: null },
            },
          },
          AND: contentFilters,
        },
        orderBy: { createdAt: 'desc' },
        skip,
        take: limit,
        select: {
          id: true,
          roomId: true,
          content: true,
          createdAt: true,
          room: {
            select: {
              name: true,
              participants: {
                where: { leftAt: null },
                select: {
                  user: {
                    select: {
                      id: true,
                      username: true,
                      fullName: true,
                      avatar: true,
                    },
                  },
                },
              },
            },
          },
        },
      }),
      this.prisma.chatMessage.count({
        where: {
          type: MessageType.SYSTEM,
          room: {
            participants: {
              some: { userId, leftAt: null },
            },
          },
          AND: contentFilters,
        },
      }),
    ]);

    // Parse raw messages into structured CallRecord objects
    const records: CallRecord[] = [];
    for (const msg of messages) {
      const parsed = this.parseCallContent(msg.content);
      if (!parsed) continue;

      // Apply filter on the parsed data (since we can't do JSON key filter in Prisma)
      if (!this.matchesFilter(parsed, filter)) continue;

      // Exclude the current user from the "other participants" list
      const otherParticipants = msg.room.participants
        .map((p) => p.user)
        .filter((u) => u.id !== userId);

      records.push({
        messageId: msg.id,
        roomId: msg.roomId,
        roomName: msg.room.name ?? null,
        callType: parsed.callType,
        status: parsed.status,
        duration: parsed.duration,
        createdAt: msg.createdAt,
        participants: otherParticipants,
      });
    }

    const totalPages = Math.ceil(totalCount / limit);

    return {
      type: 'pagination',
      message: 'Call history fetched successfully',
      data: {
        items: records,
        totalCount,
        currentPage: page,
        pageSize: limit,
      },
    };
  }

  // ---------------------------------------------------------------------------
  // Private helpers
  // ---------------------------------------------------------------------------

  private buildContentFilters(
    filter: string,
  ): { content: { contains: string } }[] {
    // Always require the 'kind':'call' marker (safe substring search)
    const base = [{ content: { contains: '"kind":"call"' } }];
    return base;
  }

  private parseCallContent(
    raw: string,
  ): { callType: CallTypeEnum; status: CallStatus; duration: number } | null {
    try {
      const parsed = JSON.parse(raw);
      if (
        parsed &&
        parsed.kind === 'call' &&
        (parsed.callType === 'audio' || parsed.callType === 'video') &&
        (parsed.status === 'missed' || parsed.status === 'ended') &&
        typeof parsed.duration === 'number'
      ) {
        return {
          callType: parsed.callType as CallTypeEnum,
          status: parsed.status as CallStatus,
          duration: parsed.duration,
        };
      }
    } catch {
      // Not a valid call descriptor
    }
    return null;
  }

  private matchesFilter(
    data: { callType: CallTypeEnum; status: CallStatus },
    filter: string,
  ): boolean {
    if (filter === 'all') return true;
    if (filter === 'missed') return data.status === 'missed';
    if (filter === 'audio') return data.callType === 'audio';
    if (filter === 'video') return data.callType === 'video';
    return true;
  }
}
