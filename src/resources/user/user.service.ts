import {
  BadRequestException,
  ForbiddenException,
  Injectable,
  NotFoundException,
} from '@nestjs/common';
import {
  generateSecureVerificationCode,
  handleDefaultError,
  processDataObject,
} from 'src/global/functions.global';
import {
  IDecodedAccecssTokenType,
  IPaginationResponseType,
  IResponseType,
} from 'src/interfaces/interfaces.global';
import {
  followDataSelect,
  FollowDataType,
  userDataSelect,
  UserDataType,
  UserDataWithIsFollowedType,
} from 'src/libs/prisma-types';
import { PrismaService } from 'src/prisma/prisma.service';
import {
  BanUserDto,
  UpdateProfileDto,
  UserActiveByCodeDto,
} from 'src/resources/user/dto/user.dto';
import { SupabaseService } from 'src/services/supabase/supabase.service';
import { EmailService } from 'src/resources/email/email.service';
import { addMinutes, isPast } from 'date-fns';
import { Prisma } from '@prisma/client';
import { Decimal } from '@prisma/client/runtime/library';
import { S3Service } from 'src/services/aws/s3/s3.service';
import { IMAGE_PROCESS_OPTIONS } from 'src/constants/file.constants';
import { NotificationService } from 'src/resources/notification/notification.service';

@Injectable()
export class UserService {
  constructor(
    private readonly prisma: PrismaService,
    private readonly supabase: SupabaseService,
    private readonly emailService: EmailService,
    private readonly s3Service: S3Service,
    private readonly notificationService: NotificationService,
  ) {}

  /**
   * Gets all users with pagination and search functionality
   *
   * @param keywords Optional search term to filter users by username, email, fullName or displayName
   * @param limit Optional number of users per page (default: 10)
   * @param page Optional page number (default: 1)
   * @returns Promise containing paginated user data and metadata
   */

  async validateUser<T = UserDataType>({
    userId,
    selectData,
  }: {
    userId: string;
    selectData: Prisma.UserSelect;
  }): Promise<T> {
    try {
      if (!userId) throw new BadRequestException('User ID is required');
      const user = await this.prisma.user.findUnique({
        where: { id: userId },
        select: selectData,
      });
      if (!user) throw new NotFoundException('User not found');
      return user as T;
    } catch (error) {
      handleDefaultError(error);
    }
  }

  async getAllUsers({
    keywords = '',
    limit = 10,
    page = 1,
    followerId,
  }: {
    keywords?: string;
    limit?: number;
    page?: number;
    followerId?: string;
  }): Promise<
    IPaginationResponseType<UserDataType | UserDataWithIsFollowedType>
  > {
    try {
      // Build where query to search across multiple user fields
      const whereQuery: Prisma.UserWhereInput = {
        OR: [
          { username: { contains: keywords } },
          { email: { contains: keywords } },
          { fullName: { contains: keywords } },
          { displayName: { contains: keywords } },
        ],
      };

      // Execute count and find queries in a transaction for consistency
      const [totalCount, users] = await this.prisma.$transaction([
        // Get total count of matching users
        this.prisma.user.count({ where: whereQuery }),
        // Get paginated users with ordering
        this.prisma.user.findMany({
          where: whereQuery,
          skip: (page - 1) * limit, // Calculate offset
          take: limit,
          orderBy: {
            createdAt: 'desc', // Sort by newest first
          },
          select: {
            ...userDataSelect,
            followers: {
              where: { followerId: followerId || '' },
              select: { followerId: true },
            },
          },
        }),
      ]);

      // Calculate pagination metadata
      const totalPage = Math.ceil(totalCount / limit);
      const hasNextPage = page < totalPage;
      const hasPreviousPage = !!totalCount && page > 1;

      const result = users.map(({ followers, ...user }) => ({
        ...user,
        isFollowedByUser: followers?.length > 0 || false,
      }));

      // Return formatted response
      return {
        message: 'Get all users successfully',
        data: {
          currentPage: page,
          totalCount,
          totalPage,
          pageSize: limit,
          hasNextPage,
          hasPreviousPage,
          items: result,
        },
        statusCode: 200,
        date: new Date(),
      };
    } catch (error) {
      handleDefaultError(error);
    }
  }

  /**
   * Retrieves user information based on the decoded access token.
   *
   * @param decodedAccessToken The decoded access token containing user information.
   * @returns A promise that resolves to an object containing the response type.
   */
  async getInformation(
    decodedAccessToken: IDecodedAccecssTokenType,
  ): Promise<IResponseType<UserDataType>> {
    try {
      // Attempt to find the user by their ID from the decoded access token
      const user = await this.prisma.user.findUnique({
        where: {
          id: decodedAccessToken.userId,
        },
        // Select the fields to include in the user data
        select: userDataSelect,
      });

      // If no user is found, throw an exception
      if (!user) throw new NotFoundException('User not found');

      // Construct and return the response object
      return {
        message: 'Get user information successfully',
        data: user,
        statusCode: 200,
        date: new Date(),
      };
    } catch (error) {
      // Handle any errors that occur during the process
      handleDefaultError(error);
    }
  }

  /**
   * Get user information by userId or username, with optional follower status check
   *
   * @param userId - The user ID or username to look up
   * @param followerId - Optional ID to check if this user follows the target user
   * @returns Promise with user data and optional isFollowedByUser flag
   */
  async getUserInformation({
    userId,
    followerId,
  }: {
    userId: string;
    followerId: string;
  }): Promise<IResponseType<UserDataType | UserDataWithIsFollowedType>> {
    try {
      // Validate that userId is provided
      if (!userId) throw new BadRequestException('User ID is required');

      // Find user by either username or id
      const user = await this.prisma.user.findFirst({
        where: {
          OR: [{ username: userId }, { id: userId }],
        },
        select: {
          // Include standard user fields
          ...userDataSelect,
          // Conditionally include followers data if followerId is provided
          followers: followerId
            ? {
                where: { followerId },
                select: { followerId: true },
              }
            : false,
        },
      });

      // Throw error if user not found
      if (!user) throw new NotFoundException('User not found');

      // Extract followers data and prepare result
      const { followers, ...userResult } = user;
      // const result =
      //   followerId && followers?.length > 0
      //     ? { ...userResult, isFollowedByUser: true }
      //     : userResult;

      const result = {
        ...userResult,
        isFollowedByUser: followers?.length > 0 || false,
      };

      // Return success response
      return {
        message: 'Get user information successfully',
        data: result,
        statusCode: 200,
        date: new Date(),
      };
    } catch (error) {
      handleDefaultError(error);
    }
  }

  /**
   * Bans or unbans a user based on the provided data.
   *
   * @param userId The ID of the user to be banned or unbanned.
   * @param data The data object containing the ban status.
   * @returns A promise that resolves to an object containing the response type.
   */
  async banUser(
    userId: string,
    data: BanUserDto,
  ): Promise<IResponseType<null>> {
    try {
      // Check if the userId is provided
      if (!userId) throw new BadRequestException('User ID is required');

      // Update the user's ban status
      await this.prisma.user.update({
        where: { id: userId },
        data: { isBanned: data.isBanned },
      });

      // Construct the response message based on the ban status
      const action = data.isBanned ? 'Ban' : 'Unban';
      return {
        message: `${action} user successfully`,
        data: null,
        statusCode: 200,
        date: new Date(),
      };
    } catch (error) {
      // Handle any errors that occur during the process
      handleDefaultError(error);
    }
  }

  async updateInformation(
    decodedAccessToken: IDecodedAccecssTokenType,
    data: UpdateProfileDto,
  ): Promise<IResponseType<UserDataType>> {
    try {
      // Iterate through each key in the data object to process the values.
      const processedData = await processDataObject(data);
      // Update the user with the processed data.
      const user = await this.prisma.user.update({
        where: {
          id: decodedAccessToken.userId,
        },
        data: {
          ...processedData,
          additionalInfo: {
            upsert: {
              create: {
                ...processedData.additionalInfo,
                userId: decodedAccessToken.userId,
              },
              update: processedData.additionalInfo,
              where: {
                userId: decodedAccessToken.userId,
              },
            },
          },
        },
        select: userDataSelect,
      });
      // Throw an error if the user is not found.
      if (!user) throw new NotFoundException('User not found');

      // Return a successful response with the updated user data.
      return {
        message: 'Update information successfully',
        data: user,
        statusCode: 200,
        date: new Date(),
      };
    } catch (error) {
      // Handle any errors that occur during the process.
      handleDefaultError(error);
    }
  }

  /**
   * Updates the information of a user.
   *
   * @param userId The ID of the user whose information will be updated.
   * @param data The data object containing the updated information.
   * @returns A promise that resolves to an object containing the response type, including the user's updated information.
   */
  async updateUserInformation(userId: string, data: UpdateProfileDto) {
    try {
      // Check if the userId is provided and throw an error if not.
      if (!userId) throw new BadRequestException('User ID is required');

      // Iterate through each key in the data object to process the values.
      const processedData = await processDataObject(data);

      const { additionalInfo, ...restData } = processedData;

      let userAdditionalInfo = await this.prisma.userAdditionalInfo.findUnique({
        where: {
          userId: userId,
        },
        select: {
          id: true,
        },
      });

      if (!userAdditionalInfo) {
        userAdditionalInfo = await this.prisma.userAdditionalInfo.create({
          data: {
            userId: userId,
            ...additionalInfo,
          },
        });

        await this.prisma.user.update({
          where: {
            id: userId,
          },
          data: {
            userAdditionalInfoId: userAdditionalInfo.id,
          },
        });
      }

      // Update the user with the processed data.
      const user = await this.prisma.user.update({
        where: {
          id: userId,
        },
        data: {
          ...restData,
          additionalInfo: {
            update: {
              data: {
                ...additionalInfo,
              },
              where: {
                userId: userId,
              },
            },
          },
        },
        select: userDataSelect,
      });
      // Throw an error if the user is not found.
      if (!user) throw new NotFoundException('User not found');

      // Return a successful response with the updated user data.
      return {
        message: 'Update user information successfully',
        data: user,
        statusCode: 200,
        date: new Date(),
      };
    } catch (error) {
      // Handle any errors that occur during the process.
      handleDefaultError(error);
    }
  }

  /**
   * Updates the avatar of a user.
   *
   * @param userId The ID of the user whose avatar will be updated.
   * @param file The file object containing the new avatar.
   * @returns A promise that resolves to an object containing the response type, including the user's updated avatar.
   */
  async updateUserAvatar(
    userId: string,
    file: Express.Multer.File,
  ): Promise<IResponseType<UserDataType>> {
    try {
      // Check if the userId is provided and throw an error if not.
      if (!userId) throw new BadRequestException('User ID is required');

      // Find the user by their ID to ensure they exist.
      const checkUser = await this.prisma.user.findUnique({
        where: { id: userId },
      });

      // Throw an error if the user is not found.
      if (!checkUser) throw new NotFoundException('User not found');

      // Upload the file to the storage service and get the URL of the uploaded file.
      // const { url } = await this.supabase.uploadFile(file);

      //Upload the file to the storage service and get the URL of the uploaded file.
      const { url } = await this.s3Service.uploadFile(
        file,
        file.originalname,
        {},
      );

      // Update the user's avatar with the URL of the uploaded file.
      const updatedUser = await this.prisma.user.update({
        where: { id: userId },
        data: { avatar: url },
        select: userDataSelect,
      });

      // Return a successful response with the updated user data.
      return {
        message: 'Update user avatar successfully',
        data: updatedUser,
        statusCode: 200,
        date: new Date(),
      };
    } catch (error) {
      // Handle any errors that occur during the process.
      handleDefaultError(error);
    }
  }

  async updateUserCoverImage({
    userId,
    file,
  }: {
    userId: string;
    file: Express.Multer.File;
  }): Promise<IResponseType<UserDataType>> {
    try {
      const user = await this.validateUser({
        userId,
        selectData: null,
      });

      // const { url } = await this.supabase.uploadFile(file);

      //Upload the file to the storage service and get the URL of the uploaded file.
      const { url } = await this.s3Service.uploadFile(
        file,
        file.originalname,
        IMAGE_PROCESS_OPTIONS,
      );

      const updatedUser = await this.prisma.user.update({
        where: { id: user.id },
        data: { coverImage: url },
        select: userDataSelect,
      });
      return {
        message: 'Update user cover image successfully',
        data: updatedUser,
        statusCode: 200,
        date: new Date(),
      };
    } catch (error) {
      handleDefaultError(error);
    }
  }

  /**
   * Updates the credits of a user.
   *
   * @param userId The ID of the user whose credits will be updated.
   * @param data An object containing the updated credits amount.
   * @returns A promise that resolves to an object containing the response type, including the user's updated data.
   */
  async updateUserCredits(
    userId: string,
    data: {
      credits: number;
    },
  ): Promise<
    IResponseType<{
      id: string;
      username: string;
      credits: Decimal;
    }>
  > {
    try {
      if (!userId) throw new BadRequestException('User id is required');
      // Update the user's credits with the provided data.
      const updatedUser = await this.prisma.user.update({
        where: { id: userId },
        data,
        // Select the user's ID, username, and updated credits for the response.
        select: { id: true, username: true, credits: true },
      });

      // Check if the user was found and throw an exception if not.
      if (!updatedUser) throw new NotFoundException('User not found');

      // Return a successful response with the updated user data.
      return {
        message: 'Update user credits successfully',
        data: updatedUser,
        statusCode: 200,
        date: new Date(),
      };
    } catch (error) {
      // Handle any errors that occur during the process.
      handleDefaultError(error);
    }
  }

  /**
   * Adds credits to a user's account.
   *
   * @param userId The ID of the user to whom credits will be added.
   * @param data An object containing the amount of credits to be added.
   * @returns A promise that resolves to an object containing the response type, including the user's updated data.
   */
  async addUserCredits(
    userId: string,
    data: {
      credits: number;
    },
  ): Promise<
    IResponseType<{
      id: string;
      username: string;
      credits: Decimal;
    }>
  > {
    try {
      if (!userId) throw new BadRequestException('User id is required');
      // Update the user's credits by incrementing the current amount with the provided data.
      const updatedUser = await this.prisma.user.update({
        where: { id: userId },
        data: {
          credits: {
            increment: data.credits,
          },
        },
        // Select the user's ID, username, and updated credits for the response.
        select: { id: true, username: true, credits: true },
      });

      // Check if the user was found and throw an exception if not.
      if (!updatedUser) throw new NotFoundException('User not found');

      // Return a successful response with the updated user data.
      return {
        message: 'Add user credits successfully',
        data: updatedUser,
        statusCode: 200,
        date: new Date(),
      };
    } catch (error) {
      // Handle any errors that occur during the process.
      handleDefaultError(error);
    }
  }

  async sendVerificationEmail(userId: string): Promise<IResponseType> {
    try {
      // Define the expiration time in minutes
      const EXPIRATION_MINUTES = 10;
      const currentDate = new Date();
      // Check if userId is provided
      if (!userId) throw new BadRequestException('User ID is required');

      // Find the user by ID
      const user = await this.prisma.user.findUnique({
        where: { id: userId },
      });

      // Check if user exists
      if (!user) throw new NotFoundException('User not found');
      // Check if user is already active
      if (user.isActive)
        throw new BadRequestException('User is already active');

      // Generate active code
      const checkCode = await this.prisma.activeCode.findFirst({
        where: {
          userId: user.id,
        },
      });

      // Determine the active code to use
      let activeCode = checkCode?.code || generateSecureVerificationCode();

      // If no active code exists, create a new one
      if (!checkCode) {
        await this.prisma.activeCode.create({
          data: {
            userId: user.id,
            code: activeCode,
            createdAt: currentDate,
            expiresAt: addMinutes(currentDate, EXPIRATION_MINUTES),
          },
        });
      } else {
        // Check if the existing active code has expired
        const isExpired = isPast(new Date(checkCode.expiresAt));
        if (isExpired) {
          // Generate a new active code if the existing one has expired
          activeCode = generateSecureVerificationCode();
          await this.prisma.activeCode.update({
            where: { id: checkCode.id },
            data: {
              code: activeCode,
              createdAt: currentDate,
              expiresAt: addMinutes(currentDate, EXPIRATION_MINUTES),
            },
          });
        }
      }

      // Send the verification email with the active code
      await this.emailService.sendActiveAccountEmail({
        email: user.email,
        context: {
          name: user.fullName,
          verification_code: activeCode, // TODO: Generate verification code
        },
      });

      // Return success response
      return {
        message: 'Verification email sent successfully',
        data: null,
        statusCode: 200,
        date: new Date(),
      };
    } catch (error) {
      handleDefaultError(error);
    }
  }

  /**
   * Activate a user account using verification code
   * @param userId - ID of the user to activate
   * @param verificationData - Object containing verification code
   * @returns Response with activated user data
   */
  async userActiveByCode(
    userId: string,
    verificationData: UserActiveByCodeDto,
  ): Promise<IResponseType<UserDataType>> {
    try {
      // Validate user ID is provided
      if (!userId) throw new BadRequestException('User ID is required');

      // Find user by ID
      const user = await this.prisma.user.findUnique({
        where: { id: userId },
      });
      if (!user) throw new NotFoundException('User not found');
      if (user.isActive) throw new ForbiddenException('User is already active');

      // Check if verification code exists and matches
      const checkCode = await this.prisma.activeCode.findFirst({
        where: {
          userId: user.id,
          code: verificationData.verifyCode,
        },
      });

      if (!checkCode) throw new ForbiddenException('Invalid verification code');

      // Check if verification code has expired
      const isExpired = isPast(new Date(checkCode.expiresAt));
      if (isExpired) throw new ForbiddenException('Verification code expired');

      // Delete used verification code
      await this.prisma.activeCode.delete({
        where: { id: checkCode.id },
      });

      // Update user status to active
      const updatedUser = await this.prisma.user.update({
        where: { id: user.id },
        data: { isActive: true },
        select: userDataSelect,
      });

      // Return success response
      return {
        message: 'User activated successfully',
        data: updatedUser,
        statusCode: 200,
        date: new Date(),
      };
    } catch (error) {
      handleDefaultError(error);
    }
  }

  /**
   * Follow or unfollow a user
   *
   * @param followerUserId - ID of the user who wants to follow/unfollow
   * @param userId - ID of the target user to be followed/unfollowed
   * @returns Promise containing follow data and updated following user info
   */
  async followUser({
    followerUserId,
    userId,
  }: {
    followerUserId: string;
    userId: string;
  }): Promise<
    IResponseType<FollowDataType & { following: UserDataWithIsFollowedType }>
  > {
    try {
      // Validate that both user IDs are provided
      if (!userId || !followerUserId) {
        throw new BadRequestException('Missing required user IDs');
      }

      // Prevent users from following themselves
      if (userId === followerUserId) {
        throw new ForbiddenException('Cannot follow yourself');
      }

      // Check if the target user exists in database
      const targetUser = await this.prisma.user.findUnique({
        where: { id: userId },
      });
      if (!targetUser) throw new NotFoundException('Target user not found');

      // Check if a follow relationship already exists between the users
      const existingFollow = await this.prisma.follow.findFirst({
        where: {
          followerId: followerUserId,
          followingId: userId,
        },
      });

      // Execute multiple database operations in a transaction
      const [, , followResult] = await this.prisma.$transaction([
        // Update the follower count of the target user
        this.prisma.user.update({
          where: { id: userId },
          data: {
            followerCount: { [existingFollow ? 'decrement' : 'increment']: 1 },
          },
          select: userDataSelect,
        }),
        // Update the following count of the follower
        this.prisma.user.update({
          where: { id: followerUserId },
          data: {
            followingCount: { [existingFollow ? 'decrement' : 'increment']: 1 },
          },
          select: userDataSelect,
        }),
        // Either delete or create the follow relationship
        existingFollow
          ? this.prisma.follow.delete({
              where: { id: existingFollow.id },
              select: followDataSelect,
            })
          : this.prisma.follow.create({
              data: { followerId: followerUserId, followingId: userId },
              select: followDataSelect,
            }),
      ]);

      // Send notification to the target user
      await this.notificationService.createFollowNotification({
        recipientId: userId,
        senderId: followerUserId,
        senderData: followResult.follower,
      });

      // Return success response with updated follow data
      return {
        message: `${existingFollow ? 'Unfollow' : 'Follow'} user successfully`,
        data: {
          ...followResult,
          following: {
            ...followResult.following,
            isFollowedByUser: !existingFollow,
          },
        },
        statusCode: 200,
        date: new Date(),
      };
    } catch (error) {
      handleDefaultError(error);
    }
  }

  /**
   * Get followers of a user with pagination
   * @param userId - ID of the user whose followers to get
   * @param limit - Number of followers per page (default: 10)
   * @param page - Page number to fetch (default: 1)
   * @returns Paginated list of followers with follow status
   */
  async getFollowers({
    userId,
    limit = 10,
    page = 1,
  }: {
    userId: string;
    limit?: number;
    page?: number;
  }): Promise<
    IPaginationResponseType<
      Omit<FollowDataType, 'following'> & {
        follower: UserDataWithIsFollowedType;
      }
    >
  > {
    try {
      // Validate user ID is provided
      if (!userId) throw new BadRequestException('User ID is required');

      // eslint-disable-next-line @typescript-eslint/no-unused-vars
      const { following, ...filledFollowData } = followDataSelect;

      // Build where query to get followers of specified user
      const whereQuery: Prisma.FollowWhereInput = {
        followingId: userId,
      };

      // Execute transaction to get total count and followers data
      const [totalCount, followers] = await this.prisma.$transaction([
        // Get total number of followers
        this.prisma.follow.count({ where: whereQuery }),
        // Get paginated followers with their follow status
        this.prisma.follow.findMany({
          where: whereQuery,
          skip: (page - 1) * limit,
          take: limit,
          orderBy: { createdAt: 'desc' },
          select: {
            ...filledFollowData,
            follower: {
              select: {
                ...userDataSelect,
                // Check if the user follows back
                followers: {
                  where: {
                    followerId: userId,
                  },
                  select: {
                    id: true,
                  },
                },
              },
            },
          },
        }),
      ]);

      // Calculate pagination metadata
      const totalPage = Math.ceil(totalCount / limit);
      const hasNextPage = page < totalPage;
      const hasPreviousPage = !!totalCount && page > 1;

      // Transform followers data to include isFollowedByUser flag
      const items = followers.map((followerItem) => {
        const { followers, ...follower } = followerItem.follower;

        return {
          ...followerItem,
          follower: {
            ...follower,
            isFollowedByUser: followers.length > 0,
          },
        };
      });

      // Return success response with pagination and followers data
      return {
        message: 'Get followers successfully',
        data: {
          currentPage: page,
          totalCount,
          totalPage,
          pageSize: limit,
          hasNextPage,
          hasPreviousPage,
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
   * Get followers of a user by their ID with pagination
   * @param userId - ID of the user to get followers for
   * @param limit - Number of followers per page (default: 10)
   * @param page - Page number to fetch (default: 1)
   * @param followerId - Optional ID to check if followers are followed by this user
   * @returns Paginated response containing follower data with isFollowedByUser flag
   */
  async getFollowersById({
    userId,
    limit = 10,
    page = 1,
    followerId,
  }: {
    userId: string;
    limit?: number;
    page?: number;
    followerId?: string;
  }): Promise<
    IPaginationResponseType<
      Omit<FollowDataType, 'following'> & {
        follower: UserDataWithIsFollowedType;
      }
    >
  > {
    try {
      if (!userId) throw new BadRequestException('User id is required');

      // Check if user exists
      const existedUser = await this.prisma.user.findUnique({
        where: { id: userId },
        select: userDataSelect,
      });
      if (!existedUser) throw new NotFoundException('User not found');

      // Remove 'following' field from follow data select
      // eslint-disable-next-line @typescript-eslint/no-unused-vars
      const { following, ...filledFollowData } = followDataSelect;

      // Build where query for followers
      const whereQuery: Prisma.FollowWhereInput = {
        followingId: userId,
      };

      // Execute transaction to get total count and followers data
      const [totalCount, followers] = await this.prisma.$transaction([
        this.prisma.follow.count({ where: whereQuery }),
        this.prisma.follow.findMany({
          where: whereQuery,
          skip: (page - 1) * limit,
          take: limit,
          orderBy: { createdAt: 'desc' },
          select: {
            ...filledFollowData,
            follower: {
              select: {
                ...userDataSelect,
                followers: {
                  where: {
                    followerId: followerId || '',
                  },
                  select: {
                    id: true,
                  },
                },
              },
            },
          },
        }),
      ]);

      // Calculate pagination metadata
      const totalPage = Math.ceil(totalCount / limit);
      const hasNextPage = page < totalPage;
      const hasPreviousPage = !!totalCount && page > 1;

      // Transform followers data to include isFollowedByUser flag
      const items = followers.map((followerItem) => {
        const { followers, ...follower } = followerItem.follower;
        return {
          ...followerItem,
          follower: {
            ...follower,
            isFollowedByUser: followers.length > 0,
          },
        };
      });

      // Return success response with pagination and followers data
      return {
        message: 'Get followers successfully',
        data: {
          currentPage: page,
          totalCount,
          totalPage,
          pageSize: limit,
          hasNextPage,
          hasPreviousPage,
          // following: existedUser,
          items,
        },
        statusCode: 200,
        date: new Date(),
      };
    } catch (error) {
      handleDefaultError(error);
    }
  }

  // async getFollowings({
  //   userId,
  //   limit = 10,
  //   page = 1,
  // }: {
  //   userId: string;
  //   limit?: number;
  //   page?: number;
  // }): Promise<IPaginationResponseType<UserDataWithIsFollowedType[]>> {
  //   try {
  //     const user = await this.validateUser({
  //       userId,
  //       selectData: null,
  //     });

  //     const whereQuery: Prisma.FollowWhereInput = {
  //       followerId: user.id,
  //     };

  //     const followings = await this.prisma.follow.findMany({
  //       where: whereQuery,
  //       select: followDataSelect,
  //     });
  //     return {
  //       message: 'Get followings successfully',
  //       data: followings,
  //       statusCode: 200,
  //       date: new Date(),
  //     };
  //   } catch (error) {
  //     handleDefaultError(error);
  //   }
  // }

  async getFollowings({
    userId,
    limit = 10,
    page = 1,
  }: {
    userId: string;
    limit?: number;
    page?: number;
  }): Promise<
    IPaginationResponseType<
      Omit<FollowDataType, 'follower'> & {
        following: UserDataWithIsFollowedType;
      }
    >
  > {
    try {
      // Validate user ID is provided
      if (!userId) throw new BadRequestException('User ID is required');

      // eslint-disable-next-line @typescript-eslint/no-unused-vars
      const { follower, ...filledFollowData } = followDataSelect;

      // Build where query to get followers of specified user
      const whereQuery: Prisma.FollowWhereInput = {
        followerId: userId,
      };

      // Execute transaction to get total count and followers data
      const [totalCount, followings] = await this.prisma.$transaction([
        // Get total number of followers
        this.prisma.follow.count({ where: whereQuery }),
        // Get paginated followers with their follow status
        this.prisma.follow.findMany({
          where: whereQuery,
          skip: (page - 1) * limit,
          take: limit,
          orderBy: { createdAt: 'desc' },
          select: {
            ...filledFollowData,
            following: {
              select: {
                ...userDataSelect,
                // Check if the user follows back
                following: {
                  where: {
                    followerId: userId,
                  },
                  select: {
                    id: true,
                  },
                },
              },
            },
          },
        }),
      ]);

      // Calculate pagination metadata
      const totalPage = Math.ceil(totalCount / limit);
      const hasNextPage = page < totalPage;
      const hasPreviousPage = !!totalCount && page > 1;

      // Transform followers data to include isFollowedByUser flag
      const items = followings.map((followingItem) => {
        // eslint-disable-next-line @typescript-eslint/no-unused-vars
        const { following, ...followingData } = followingItem.following;

        return {
          ...followingItem,
          following: {
            ...followingData,
            isFollowedByUser: true,
          },
        };
      });

      // Return success response with pagination and followers data
      return {
        message: 'Get followers successfully',
        data: {
          currentPage: page,
          totalCount,
          totalPage,
          pageSize: limit,
          hasNextPage,
          hasPreviousPage,
          items,
        },
        statusCode: 200,
        date: new Date(),
      };
    } catch (error) {
      handleDefaultError(error);
    }
  }

  // async getFollowingsById({
  //   userId,
  //   limit = 10,
  //   page = 1,
  // }: {
  //   userId: string;
  //   limit?: number;
  //   page?: number;
  // }): Promise<
  //   IPaginationResponseType<
  //     Omit<FollowDataType, 'follower'> & {
  //       following: UserDataWithIsFollowedType;
  //     }
  //   >
  // > {
  //   try {
  //     // Validate user ID is provided
  //     if (!userId) throw new BadRequestException('User ID is required');

  //     // eslint-disable-next-line @typescript-eslint/no-unused-vars
  //     const { follower, ...filledFollowData } = followDataSelect;

  //     // Build where query to get followers of specified user
  //     const whereQuery: Prisma.FollowWhereInput = {
  //       followerId: userId,
  //     };

  //     // Execute transaction to get total count and followers data
  //     const [totalCount, followings] = await this.prisma.$transaction([
  //       // Get total number of followers
  //       this.prisma.follow.count({ where: whereQuery }),
  //       // Get paginated followers with their follow status
  //       this.prisma.follow.findMany({
  //         where: whereQuery,
  //         skip: (page - 1) * limit,
  //         take: limit,
  //         orderBy: { createdAt: 'desc' },
  //         select: {
  //           ...filledFollowData,
  //           following: {
  //             select: {
  //               ...userDataSelect,
  //               // Check if the user follows back
  //               following: {
  //                 where: {
  //                   followerId: userId,
  //                 },
  //                 select: {
  //                   id: true,
  //                 },
  //               },
  //             },
  //           },
  //         },
  //       }),
  //     ]);

  //     // Calculate pagination metadata
  //     const totalPage = Math.ceil(totalCount / limit);
  //     const hasNextPage = page < totalPage;
  //     const hasPreviousPage = !!totalCount && page > 1;

  //     // Transform followers data to include isFollowedByUser flag
  //     const items = followings.map((followingItem) => {
  //       // eslint-disable-next-line @typescript-eslint/no-unused-vars
  //       const { following, ...followingData } = followingItem.following;

  //       return {
  //         ...followingItem,
  //         following: {
  //           ...followingData,
  //           isFollowedByUser: true,
  //         },
  //       };
  //     });

  //     // Return success response with pagination and followers data
  //     return {
  //       message: 'Get followers successfully',
  //       data: {
  //         currentPage: page,
  //         totalCount,
  //         totalPage,
  //         pageSize: limit,
  //         hasNextPage,
  //         hasPreviousPage,
  //         items,
  //       },
  //       statusCode: 200,
  //       date: new Date(),
  //     };
  //   } catch (error) {
  //     handleDefaultError(error);
  //   }
  // }
}
