import { Injectable, BadRequestException } from '@nestjs/common';
import { FriendStatus, Prisma } from '@prisma/client';
import { handleDefaultError } from 'src/global/functions.global';
import {
  IPaginationResponseType,
  IResponseType,
} from 'src/interfaces/interfaces.global';
import {
  friendDataSelect,
  friendDataSelectWithInclude,
  FriendDataType,
  userDataSelect,
  UserDataType,
} from 'src/libs/prisma-types';
import { PrismaService } from 'src/prisma/prisma.service';
import { NotificationService } from 'src/resources/notification/notification.service';
import { UserService } from 'src/resources/user/user.service';

@Injectable()
export class FriendService {
  constructor(
    private readonly prisma: PrismaService,
    private readonly notificationService: NotificationService,
    private readonly userService: UserService,
  ) {}

  async getFriendList({
    userId,
    limit = 10,
    page = 1,
  }: {
    userId: string;
    limit?: number;
    page?: number;
  }): Promise<
    IPaginationResponseType<UserDataType> & {
      data: {
        user: UserDataType;
      };
    }
  > {
    try {
      // Validate user and get friend relationships in parallel
      const [user, friendRelationships] = await Promise.all([
        this.userService.validateUser({
          userId,
          selectData: userDataSelect,
        }),
        this.prisma.friend.findMany({
          where: {
            OR: [{ userId }, { friendId: userId }],
            status: FriendStatus.ACCEPTED,
          },
          select: {
            ...friendDataSelect,
            friendId: true,
            userId: true,
          },
        }),
      ]);

      // Get the IDs of all friends (excluding the current user)
      const friendIds = friendRelationships.map((rel) =>
        rel.userId === userId ? rel.friendId : rel.userId,
      );

      // If no friends, return early with empty results
      if (friendIds.length === 0) {
        return {
          message: 'Get accepted friends successfully',
          data: {
            currentPage: page,
            totalCount: 0,
            totalPage: 0,
            pageSize: limit,
            hasNextPage: false,
            hasPreviousPage: false,
            user,
            items: [],
          },
          statusCode: 200,
          date: new Date(),
        };
      }

      // Create a map for faster friend relationship lookup
      const friendRelationshipMap = new Map();
      friendRelationships.forEach((rel) => {
        const friendId = rel.userId === userId ? rel.friendId : rel.userId;
        friendRelationshipMap.set(friendId, rel);
      });

      const [totalCount, friends] = await this.prisma.$transaction([
        this.prisma.user.count({
          where: {
            id: { in: friendIds },
          },
        }),
        this.prisma.user.findMany({
          where: {
            id: { in: friendIds },
          },
          skip: (page - 1) * limit,
          take: limit,
          select: {
            ...userDataSelect,
          },
        }),
      ]);

      // Map friends to include relationship data using the map (O(n) instead of O(n²))
      const items = friends.map((friend) => ({
        ...friend,
        // friend: friendRelationshipMap.get(friend.id) || null,
      }));

      // Calculate pagination metadata
      const totalPage = Math.ceil(totalCount / limit);
      const hasNextPage = page < totalPage;
      const hasPreviousPage = !!totalCount && page > 1;

      return {
        message: 'Get accepted friends successfully',
        data: {
          currentPage: page,
          totalCount,
          totalPage,
          pageSize: limit,
          hasNextPage,
          hasPreviousPage,
          user,
          items,
        },
        statusCode: 200,
        date: new Date(),
      };
    } catch (error) {
      handleDefaultError(error);
    }
  }

  async getFriendByUserId({
    currentUserId,
    friendId,
  }: {
    currentUserId: string;
    friendId: string;
  }): Promise<IResponseType<UserDataType>> {
    try {
      // Validate user and get friend relationships in parallel
      const [, , friendRelationship] = await Promise.all([
        this.userService.validateUser({
          userId: currentUserId,
          selectData: userDataSelect,
        }),
        this.userService.validateUser({
          userId: friendId,
          selectData: userDataSelect,
        }),
        this.prisma.friend.findFirst({
          where: {
            AND: [
              {
                OR: [
                  { userId: currentUserId, friendId: friendId },
                  { userId: friendId, friendId: currentUserId },
                ],
                status: FriendStatus.ACCEPTED,
              },
            ],
          },
          select: {
            ...friendDataSelect,
            friendId: true,
            userId: true,
          },
        }),
      ]);

      if (!friendRelationship) {
        return {
          message: 'Get accepted friends successfully',
          data: null,
          statusCode: 200,
          date: new Date(),
        };
      }

      // Get the IDs of all friends (excluding the current user)
      const friendUserId =
        friendRelationship.userId === currentUserId
          ? friendRelationship.friendId
          : friendRelationship.userId;

      const friendUserData = await this.userService.validateUser({
        userId: friendUserId,
        selectData: userDataSelect,
      });

      return {
        message: 'Get accepted friends successfully',
        data: friendUserData,
        statusCode: 200,
        date: new Date(),
      };
    } catch (error) {
      handleDefaultError(error);
    }
  }

  async getPendingFriendsRequest({
    userId,
    limit = 10,
    page = 1,
  }: {
    userId: string;
    limit?: number;
    page?: number;
  }): Promise<
    IPaginationResponseType<FriendDataType> & {
      data: {
        user: UserDataType;
      };
    }
  > {
    try {
      const user = await this.userService.validateUser({
        userId,
        selectData: userDataSelect,
      });

      const whereQuery: Prisma.FriendWhereInput = {
        OR: [
          {
            friendId: userId,
          },
        ],
        status: FriendStatus.PENDING,
      };

      const selectData: Prisma.FriendSelect = {
        ...friendDataSelect,
        user: {
          select: userDataSelect,
        },
      };

      const [totalCount, friends] = await this.prisma.$transaction([
        this.prisma.friend.count({ where: whereQuery }),
        this.prisma.friend.findMany({
          where: whereQuery,
          skip: (page - 1) * limit,
          take: limit,
          select: selectData,
        }),
      ]);

      const items = friends.map(({ user, ...friend }) => {
        return {
          ...friend,
          friend: user,
        };
      });

      // Calculate pagination metadata
      const totalPage = Math.ceil(totalCount / limit);
      const hasNextPage = page < totalPage;
      const hasPreviousPage = !!totalCount && page > 1;

      return {
        message: 'Get friends successfully',
        data: {
          currentPage: page,
          totalCount,
          totalPage,
          pageSize: limit,
          hasNextPage,
          hasPreviousPage,
          user,
          items,
        },
        statusCode: 200,
        date: new Date(),
      };
    } catch (error) {
      handleDefaultError(error);
    }
  }

  /**
   * Toggle friendship request with smart mutual detection
   *
   * Scenarios:
   * 1. If currentUser already sent request → Cancel it
   * 2. If currentUser received request → Accept it with 2-way follow
   * 3. If BOTH users sent requests to each other → Auto-accept (mutual friendship)
   * 4. Otherwise → Send new request
   *
   * @param userId - Target user ID
   * @param currentUserId - Current user ID (sender)
   */
  async toggleFriendshipRequest({
    userId,
    currentUserId,
  }: {
    userId: string;
    currentUserId: string;
  }): Promise<IResponseType<FriendDataType>> {
    try {
      const [user, currentUser] = await Promise.all([
        this.userService.validateUser({ userId, selectData: userDataSelect }),
        this.userService.validateUser({
          userId: currentUserId,
          selectData: userDataSelect,
        }),
      ]);

      // ⚡ FIXED: Use single query to prevent race condition
      // Check for ANY existing relationship between the two users
      const existingRelationships = await this.prisma.friend.findMany({
        where: {
          OR: [
            { userId: currentUser.id, friendId: user.id },
            { userId: user.id, friendId: currentUser.id },
          ],
        },
        select: friendDataSelectWithInclude,
      });

      // Separate the relationships based on direction
      const myRequest = existingRelationships.find(
        (rel) => rel.user.id === currentUser.id && rel.friend.id === user.id,
      );
      const theirRequest = existingRelationships.find(
        (rel) => rel.user.id === user.id && rel.friend.id === currentUser.id,
      );

      // ==================== SCENARIO 1: Cancel my request ====================
      if (myRequest && !theirRequest) {
        await this.prisma.friend.delete({
          where: { id: myRequest.id },
        });

        // Clean up follow relationship
        await this.userService.unfollowUser({
          followerUserId: currentUser.id,
          userId: user.id,
        });

        // Delete notifications
        await this.notificationService.deleteFriendRequestNotifications({
          userId: currentUser.id,
          friendId: user.id,
        });

        return {
          message: 'Friendship request cancelled successfully',
          data: myRequest,
          statusCode: 200,
          date: new Date(),
        };
      }

      // ==================== SCENARIO 2: Accept their request ====================
      if (theirRequest && !myRequest) {
        // Establish 2-way follow relationship
        await Promise.all([
          this.userService.followUser({
            followerUserId: currentUser.id,
            userId: user.id,
            skipNotification: true,
          }),
          // Note: user already followed currentUser when sending request
          // But we ensure it exists in case of data inconsistency
          this.userService.followUser({
            followerUserId: user.id,
            userId: currentUser.id,
            skipNotification: true,
          }),
        ]);

        // Update request to accepted status
        const [, , acceptedRequest] = await this.prisma.$transaction([
          this.prisma.user.update({
            where: { id: user.id },
            data: { friendCount: { increment: 1 } },
          }),
          this.prisma.user.update({
            where: { id: currentUser.id },
            data: { friendCount: { increment: 1 } },
          }),
          this.prisma.friend.update({
            where: { id: theirRequest.id },
            data: { status: FriendStatus.ACCEPTED },
            select: friendDataSelectWithInclude,
          }),
        ]);

        // Delete friend request notifications
        await this.notificationService.deleteFriendRequestNotifications({
          userId: user.id,
          friendId: currentUser.id,
        });

        return {
          message: 'Friendship request accepted successfully',
          data: acceptedRequest,
          statusCode: 200,
          date: new Date(),
        };
      }

      // ==================== SCENARIO 3: Mutual requests → Auto-accept ====================
      if (myRequest && theirRequest) {
        // Both users sent requests to each other → Automatic mutual friendship!

        // Establish 2-way follow relationship (if not already done)
        await Promise.all([
          this.userService.followUser({
            followerUserId: currentUser.id,
            userId: user.id,
            skipNotification: true,
          }),
          this.userService.followUser({
            followerUserId: user.id,
            userId: currentUser.id,
            skipNotification: true,
          }),
        ]);

        // Keep one relationship, delete the other, update to ACCEPTED
        const [, , acceptedRequest] = await this.prisma.$transaction([
          this.prisma.user.update({
            where: { id: user.id },
            data: { friendCount: { increment: 1 } },
          }),
          this.prisma.user.update({
            where: { id: currentUser.id },
            data: { friendCount: { increment: 1 } },
          }),
          // Update the first one to ACCEPTED
          this.prisma.friend.update({
            where: { id: myRequest.id },
            data: { status: FriendStatus.ACCEPTED },
            select: friendDataSelectWithInclude,
          }),
        ]);

        // Delete the duplicate request
        await this.prisma.friend.delete({
          where: { id: theirRequest.id },
        });

        // Delete all friend request notifications between these users
        await Promise.all([
          this.notificationService.deleteFriendRequestNotifications({
            userId: currentUser.id,
            friendId: user.id,
          }),
          this.notificationService.deleteFriendRequestNotifications({
            userId: user.id,
            friendId: currentUser.id,
          }),
        ]);

        return {
          message: 'Mutual friendship established successfully',
          data: acceptedRequest,
          statusCode: 200,
          date: new Date(),
        };
      }

      // ==================== SCENARIO 4: Send new request ====================
      // No existing relationship → Create new friend request

      // Follow the user when sending request
      await this.userService.followUser({
        followerUserId: currentUser.id,
        userId: user.id,
        skipNotification: true,
      });

      // Create new friendship request
      const newFriendshipRequest = await this.prisma.friend.create({
        data: {
          userId: currentUser.id,
          friendId: user.id,
          status: FriendStatus.PENDING,
          isRequestedByMe: true,
        },
        select: friendDataSelectWithInclude,
      });

      // Create friend request notification
      await this.notificationService.createFriendRequestNotification({
        recipientId: user.id,
        senderId: currentUser.id,
        senderData: currentUser,
        friendId: user.id,
      });

      return {
        message: 'Friendship request sent successfully',
        data: newFriendshipRequest,
        statusCode: 200,
        date: new Date(),
      };
    } catch (error) {
      handleDefaultError(error);
    }
  }

  async acceptFriendshipRequest({
    userId,
    currentUserId,
  }: {
    userId: string;
    currentUserId: string;
  }): Promise<IResponseType<FriendDataType>> {
    try {
      const user = await this.userService.validateUser({
        userId,
        selectData: {
          id: true,
        },
      });

      const friend = await this.userService.validateUser({
        userId: currentUserId,
        selectData: {
          id: true,
        },
      });

      const checkFriendshipRequestReceived = await this.prisma.friend.findFirst(
        {
          where: {
            userId: user.id,
            friendId: currentUserId,
            status: {
              not: FriendStatus.REJECTED,
            },
          },
          select: friendDataSelectWithInclude,
        },
      );

      if (!checkFriendshipRequestReceived) {
        throw new BadRequestException('Friendship request not found');
      }

      if (checkFriendshipRequestReceived.status === FriendStatus.ACCEPTED) {
        throw new BadRequestException('Friendship request already accepted');
      }

      if (checkFriendshipRequestReceived.status === FriendStatus.BLOCKED) {
        throw new BadRequestException('You blocked this user');
      }

      // Establish 2-way follow relationship
      // Note: user (sender) already followed currentUser when sending the request
      // Now currentUser follows back to complete bidirectional friendship
      await Promise.all([
        this.userService.followUser({
          followerUserId: currentUserId,
          userId,
          skipNotification: true,
        }),
        // Ensure sender's follow still exists (for data consistency)
        this.userService.followUser({
          followerUserId: userId,
          userId: currentUserId,
          skipNotification: true,
        }),
      ]);

      const [, , acceptedFriendshipRequest] = await this.prisma.$transaction([
        this.prisma.user.update({
          where: { id: user.id },
          data: { friendCount: { increment: 1 } },
        }),
        this.prisma.user.update({
          where: { id: friend.id },
          data: { friendCount: { increment: 1 } },
        }),
        this.prisma.friend.update({
          where: { id: checkFriendshipRequestReceived.id },
          data: {
            userId: user.id,
            friendId: friend.id,
            status: FriendStatus.ACCEPTED,
          },
          select: friendDataSelectWithInclude,
        }),
      ]);

      // Delete friend request notifications
      await this.notificationService.deleteFriendRequestNotifications({
        userId: userId,
        friendId: currentUserId,
      });

      return {
        message: 'Friendship request accepted successfully',
        data: {
          ...acceptedFriendshipRequest,
        },
        statusCode: 201,
        date: new Date(),
      };
    } catch (error) {
      handleDefaultError(error);
    }
  }

  async rejectFriendshipRequest({
    userId,
    currentUserId,
  }: {
    userId: string;
    currentUserId: string;
  }): Promise<IResponseType<FriendDataType>> {
    try {
      const user = await this.userService.validateUser({
        userId,
        selectData: userDataSelect,
      });

      const checkFriendshipRequest = await this.prisma.friend.findFirst({
        where: {
          userId: user.id,
          friendId: currentUserId,
          status: FriendStatus.PENDING,
        },
        select: friendDataSelectWithInclude,
      });

      if (!checkFriendshipRequest) {
        throw new BadRequestException('Friendship request not found');
      }

      const rejectedFriendshipRequest = await this.prisma.friend.delete({
        where: { id: checkFriendshipRequest.id },
        select: friendDataSelectWithInclude,
      });
      rejectedFriendshipRequest.status = 'REJECTED';

      // Delete friend request notifications
      await this.notificationService.deleteFriendRequestNotifications({
        userId: currentUserId,
        friendId: userId,
      });

      return {
        message: 'Friendship request rejected successfully',
        data: rejectedFriendshipRequest,
        statusCode: 201,
        date: new Date(),
      };
    } catch (error) {
      handleDefaultError(error);
    }
  }

  async removeFriend({
    userId,
    currentUserId,
  }: {
    userId: string;
    currentUserId: string;
  }): Promise<IResponseType<FriendDataType>> {
    try {
      const user = await this.userService.validateUser({
        userId,
        selectData: userDataSelect,
      });

      const currentUser = await this.userService.validateUser({
        userId: currentUserId,
        selectData: userDataSelect,
      });

      const checkFriend = await this.prisma.friend.findFirst({
        where: {
          OR: [
            { userId: user.id, friendId: currentUser.id },
            { userId: currentUser.id, friendId: user.id },
          ],
          status: FriendStatus.ACCEPTED,
        },
      });

      if (!checkFriend) {
        throw new BadRequestException('Friend not found');
      }

      // Remove 2-way follow relationship
      const unfollowPromises = [
        this.userService.unfollowUser({
          followerUserId: currentUserId,
          userId: user.id,
        }),
        this.userService.unfollowUser({
          followerUserId: user.id,
          userId: currentUserId,
        }),
      ];
      await Promise.all(unfollowPromises);

      const [, removedFriend] = await this.prisma.$transaction([
        this.prisma.user.updateMany({
          where: {
            id: {
              in: [user.id, currentUser.id],
            },
          },
          data: {
            friendCount: { decrement: 1 },
          },
        }),
        this.prisma.friend.delete({
          where: {
            id: checkFriend.id,
          },
          select: friendDataSelectWithInclude,
        }),
      ]);

      // Always return the current user as the friend
      if (removedFriend.friend.id !== currentUser.id) {
        removedFriend.friend = currentUser;
      }

      if (removedFriend.user.id === currentUser.id) {
        removedFriend.user = user;
      }

      return {
        message: 'Friend removed successfully',
        data: removedFriend,
        statusCode: 201,
        date: new Date(),
      };
    } catch (error) {
      handleDefaultError(error);
    }
  }

  async toggleBlockFriend({
    userId,
    currentUserId,
  }: {
    userId: string;
    currentUserId: string;
  }): Promise<IResponseType<FriendDataType>> {
    try {
      const user = await this.userService.validateUser({
        userId,
        selectData: userDataSelect,
      });

      const currentUser = await this.userService.validateUser({
        userId: currentUserId,
        selectData: userDataSelect,
      });

      const checkFriend = await this.prisma.friend.findFirst({
        where: {
          OR: [
            { userId: user.id, friendId: currentUser.id },
            { userId: currentUser.id, friendId: user.id },
          ],
        },
      });

      if (checkFriend?.status === FriendStatus.BLOCKED) {
        const blockedFriend = await this.prisma.friend.delete({
          where: {
            id: checkFriend.id,
          },
          select: friendDataSelectWithInclude,
        });

        return {
          message: 'Friend unblocked successfully',
          data: {
            ...blockedFriend,
          },
          statusCode: 201,
          date: new Date(),
        };
      }

      const isFriend = checkFriend?.status === FriendStatus.ACCEPTED;

      if (isFriend) {
        await this.prisma.$transaction([
          // Delete friendship

          this.prisma.friend.delete({
            where: {
              id: checkFriend.id,
            },
          }),

          // Decrement friend count of current user

          this.prisma.user.updateMany({
            where: {
              id: {
                in: [user.id, currentUser.id],
              },
            },
            data: {
              friendCount: { decrement: 1 },
            },
          }),
        ]);
      }

      // Create blocked friendship
      const newBlockedFriend = await this.prisma.friend.create({
        data: {
          userId: currentUser.id,
          friendId: user.id,
          status: FriendStatus.BLOCKED,
        },
        select: friendDataSelectWithInclude,
      });

      return {
        message: 'Friend blocked successfully',
        data: {
          ...newBlockedFriend,
        },
        statusCode: 201,
        date: new Date(),
      };
    } catch (error) {
      handleDefaultError(error);
    }
  }
}
