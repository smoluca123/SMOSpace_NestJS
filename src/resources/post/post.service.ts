import {
  BadRequestException,
  ForbiddenException,
  Injectable,
  NotFoundException,
} from '@nestjs/common';
import { FriendStatus, Prisma } from '@prisma/client';
import type { ReactionType } from '@prisma/client';
import openai from 'src/configs/openai.config';
import {
  blockResultMessage,
  POST_AI_PROMPTS,
} from 'src/global/constant.global';
import { handleDefaultError } from 'src/global/functions.global';
import {
  IBaseResponseAIType,
  IBeforeTransformResponseType,
  IDecodedAccecssTokenType,
  IPaginationResponseType,
  IResponseType,
} from 'src/interfaces/interfaces.global';
import {
  postDataSelect,
  PostDataType,
  PostDataTypeWithLikes,
  PostDataTypeWithLikeStatus,
  PostLikeDataType,
  PostReactionCounts,
  TrendingTopicType,
  userDataSelect,
  // TrendingTopicType,
} from 'src/libs/prisma-types';
import { PrismaService } from 'src/prisma/prisma.service';
import { PostGateway } from 'src/resources/gateways/post/post.gateway';
import {
  CreatePostDto,
  GenerateImagesDto,
  UpdatePostAsAdminDto,
  UpdatePostDto,
} from 'src/resources/post/dto/post.dto';
import { S3Service } from 'src/services/aws/s3/s3.service';
import { NotificationService } from 'src/resources/notification/notification.service';
import { UUID } from 'crypto';
import axios, { AxiosRequestConfig } from 'axios';
import { ConfigService } from '@nestjs/config';
import { generateImagesSchema } from 'src/resources/user/user.schemas';
import { IGenerateImagesResponseType } from 'src/interfaces/ai.interfaces';
import { UserService } from 'src/resources/user/user.service';

@Injectable()
export class PostService {
  constructor(
    private readonly prisma: PrismaService,
    private readonly postGateway: PostGateway,
    private readonly s3Service: S3Service,
    private readonly notificationService: NotificationService,
    private readonly configService: ConfigService,
    private readonly userService: UserService,
  ) {}
  async validatePost<DataType = PostDataType>(
    postId: string,
    select?: Prisma.PostSelect,
  ): Promise<DataType> {
    try {
      if (!postId) {
        throw new BadRequestException('Post id is required');
      }

      const post = await this.prisma.post.findUnique({
        where: { id: postId },
        select: select || postDataSelect,
      });

      if (!post) {
        throw new NotFoundException('Post not found');
      }
      return post as DataType;
    } catch (error) {
      handleDefaultError(error);
    }
  }

  async getPostCount(): Promise<
    IBeforeTransformResponseType<{
      totalPostsCount: number;
      publicPostsCount: number;
      privatePostsCount: number;
    }>
  > {
    try {
      const count = await this.prisma.post.count();
      const countPrivate = await this.prisma.post.count({
        where: {
          isPrivate: true,
        },
      });

      return {
        type: 'response',
        message: 'Post count fetched successfully',
        data: {
          totalPostsCount: count,
          publicPostsCount: count - countPrivate,
          privatePostsCount: countPrivate,
        },
      };
    } catch (error) {
      handleDefaultError(error);
    }
  }

  /**
   * Returns the list of user IDs that are blocked relative to the given user,
   * in either direction (users they blocked + users who blocked them).
   */
  private async getBlockedUserIds(currentUserId?: string): Promise<string[]> {
    if (!currentUserId) return [];

    const blockedRelationships = await this.prisma.friend.findMany({
      where: {
        status: FriendStatus.BLOCKED,
        OR: [{ userId: currentUserId }, { friendId: currentUserId }],
      },
      select: { userId: true, friendId: true },
    });

    return blockedRelationships.map((rel) =>
      rel.userId === currentUserId ? rel.friendId : rel.userId,
    );
  }

  // ==================== REACTION HELPERS ====================

  private static readonly REACTION_TYPES: ReactionType[] = [
    'LIKE',
    'LOVE',
    'HAHA',
    'WOW',
    'SAD',
    'ANGRY',
  ];

  /** Empty per-type reaction counter, all entries set to 0. */
  private buildEmptyReactionCounts(): PostReactionCounts {
    return PostService.REACTION_TYPES.reduce((acc, type) => {
      acc[type] = 0;
      return acc;
    }, {} as PostReactionCounts);
  }

  /**
   * Aggregate reaction counts (per `ReactionType`) for the given posts in a
   * single grouped query - avoids N+1 when listing feeds.
   * Returns a map: `postId -> PostReactionCounts`.
   */
  private async getReactionCountsByPostIds(
    postIds: string[],
  ): Promise<Map<string, PostReactionCounts>> {
    const result = new Map<string, PostReactionCounts>();
    if (postIds.length === 0) return result;

    const groups = await this.prisma.postLike.groupBy({
      by: ['postId', 'type'],
      where: { postId: { in: postIds } },
      _count: { _all: true },
    });

    for (const { postId, type, _count } of groups) {
      const counts = result.get(postId) ?? this.buildEmptyReactionCounts();
      counts[type] = _count._all;
      result.set(postId, counts);
    }

    return result;
  }

  /** Convenience for a single post id. */
  private async getReactionCountsByPostId(
    postId: string,
  ): Promise<PostReactionCounts> {
    const map = await this.getReactionCountsByPostIds([postId]);
    return map.get(postId) ?? this.buildEmptyReactionCounts();
  }

  async getPosts({
    keywords = '',
    limit,
    page,
    userId,
    likeUserId,
    getPrivatePost = false,
    followUserId,
    hashtag,
  }: {
    keywords?: string;
    limit: number;
    page: number;
    userId?: string;
    likeUserId?: string;
    getPrivatePost?: boolean;
    followUserId?: string;
    hashtag?: string;
  }): Promise<IPaginationResponseType<PostDataType>> {
    try {
      // Users blocked by (or blocking) the viewer should never appear in feeds.
      const blockedUserIds = await this.getBlockedUserIds(likeUserId);

      const whereQuery: Prisma.PostWhereInput = {
        authorId: userId || undefined,
        ...(!getPrivatePost ? { isPrivate: false } : {}),
        ...(blockedUserIds.length
          ? { NOT: { authorId: { in: blockedUserIds } } }
          : {}),
        ...(hashtag
          ? { content: { contains: `#${hashtag}`, mode: 'insensitive' } }
          : {}),
        ...(followUserId
          ? {
              author: {
                followers: {
                  some: {
                    followerId: followUserId,
                  },
                },
              },
            }
          : {}),
        OR: [
          {
            content: {
              contains: keywords,
              mode: 'insensitive',
            },
          },
          {
            content: {
              search: keywords,
              mode: 'insensitive',
            },
          },
        ],
      };

      const [totalCount, posts] = await this.prisma.$transaction([
        this.prisma.post.count({ where: whereQuery }),
        this.prisma.post.findMany({
          where: whereQuery,
          take: limit,
          skip: (page - 1) * limit,
          select: {
            ...postDataSelect,
            likes: {
              where: {
                userId: likeUserId || '',
              },
              select: {
                userId: true,
                type: true,
              },
            },
            bookmarks: {
              where: {
                userId: likeUserId || '',
              },
              select: {
                id: true,
              },
            },
          },
          // include: {
          //   ...postDataInclude,
          //   likes: {
          //     where: {
          //       userId: userId || '',
          //     },
          //     select: {
          //       userId: true,
          //     },
          //   },
          // },
          orderBy: { createdAt: 'desc' },
        }),
      ]);

      const reactionCountsByPost = await this.getReactionCountsByPostIds(
        posts.map((post) => post.id),
      );

      const postsWithLikeStatus = posts.map(
        ({ likes, bookmarks, ...post }) => ({
          ...post,
          isLiked: likes.length > 0,
          myReaction: likes[0]?.type ?? null,
          reactionCounts:
            reactionCountsByPost.get(post.id) ??
            this.buildEmptyReactionCounts(),
          isBookmarked: bookmarks.length > 0,
        }),
      );

      const totalPage = Math.ceil(totalCount / limit);
      const hasNextPage = page * limit < totalCount;
      const hasPreviousPage = !!totalCount && page > 1;

      return {
        message: 'Posts fetched successfully',
        data: {
          totalCount,
          totalPage,
          currentPage: page,
          pageSize: limit,
          hasNextPage,
          hasPreviousPage,
          items: postsWithLikeStatus,
        },
        statusCode: 200,
        date: new Date(),
      };
    } catch (error) {
      handleDefaultError(error);
    }
  }

  async getPostById({
    postId,
    likeUserId,
  }: {
    postId: string;
    likeUserId?: string;
  }): Promise<IResponseType<PostDataTypeWithLikeStatus>> {
    try {
      const post = await this.validatePost<
        PostDataTypeWithLikes & { bookmarks: { id: string }[] }
      >(postId, {
        ...postDataSelect,
        likes: {
          where: {
            userId: likeUserId || '',
          },
          select: {
            userId: true,
            type: true,
          },
        },
        bookmarks: {
          where: {
            userId: likeUserId || '',
          },
          select: {
            id: true,
          },
        },
      });

      if (!post) {
        throw new NotFoundException({
          message: 'Post not found',
          statusCode: 404,
          date: new Date(),
        });
      }

      // Check if post is private and user is not the owner
      if (post.isPrivate) {
        if (!likeUserId || post.author.id !== likeUserId) {
          throw new ForbiddenException({
            message: 'You do not have permission to view this private post',
            statusCode: 403,
            date: new Date(),
          });
        }
      }

      const reactionCounts = await this.getReactionCountsByPostId(post.id);

      // eslint-disable-next-line @typescript-eslint/no-unused-vars
      const { likes, bookmarks, ...postWithLikeStatus } = {
        ...post,
        isLiked: post.likes.length > 0,
        myReaction:
          (post.likes[0] as { type?: ReactionType } | undefined)?.type ?? null,
        reactionCounts,
        isBookmarked: post.bookmarks.length > 0,
      };

      return {
        message: 'Post fetched successfully',
        data: postWithLikeStatus,
        statusCode: 200,
        date: new Date(),
      };
    } catch (error) {
      handleDefaultError(error);
    }
  }

  async getLikesPost({
    postId,
    limit,
    page,
    userId,
    type,
  }: {
    postId: string;
    page: number;
    limit: number;
    userId?: string;
    type?: ReactionType;
  }): Promise<
    IPaginationResponseType<Omit<PostLikeDataType, 'post'>> & {
      data: {
        post: PostDataType;
      };
    }
  > {
    try {
      if (!postId) {
        throw new BadRequestException({
          message: 'Post id is required',
          statusCode: 400,
          date: new Date(),
        });
      }

      const post = await this.prisma.post.findUnique({
        where: {
          id: postId,
        },
        select: postDataSelect,
      });
      if (!post) {
        throw new NotFoundException({
          message: 'Post not found',
          statusCode: 404,
          date: new Date(),
        });
      }

      const whereQuery: Prisma.PostLikeWhereInput = {
        postId,
        ...(userId ? { userId } : {}),
        ...(type ? { type } : {}),
      };

      const [likes, totalCount] = await this.prisma.$transaction([
        this.prisma.postLike.findMany({
          where: whereQuery,
          take: limit,
          skip: (page - 1) * limit,
          orderBy: { createdAt: 'desc' },

          select: {
            id: true,
            type: true,
            createdAt: true,
            user: {
              select: userDataSelect,
            },
          },
        }),
        this.prisma.postLike.count({
          where: whereQuery,
        }),
      ]);

      const currentPage = page;
      const totalPage = Math.ceil(totalCount / limit);
      const hasNextPage = page * limit < totalCount;
      const hasPreviousPage = !!totalCount && page > 1;

      return {
        message: 'Likes fetched successfully',
        data: {
          post,
          items: likes,
          currentPage,
          totalPage,
          totalCount,
          hasNextPage,
          hasPreviousPage,
          pageSize: limit,
        },
        statusCode: 200,
        date: new Date(),
      };
    } catch (error) {
      handleDefaultError(error);
    }
  }

  async getTrendingTopics() {
    try {
      if (!(await this.prisma.post.count())) {
        return {
          message: 'No topics found',
          data: [],
          statusCode: 200,
          date: new Date(),
        };
      }

      const result = await this.prisma.$queryRaw<TrendingTopicType[]>`
        SELECT LOWER(unnest(regexp_matches(content, '#[[:alnum:]_'']+', 'g'))) AS hashtag, COUNT(*) AS count
        FROM posts
        GROUP BY (hashtag)
        ORDER BY count DESC, hashtag ASC
        LIMIT 5;
      `;

      const topics = result.map((row) => ({
        hashtag: row.hashtag,
        count: Number(row.count),
      }));

      return {
        message: 'Trending topics fetched successfully',
        data: topics,
        statusCode: 200,
        date: new Date(),
      };
    } catch (error) {
      handleDefaultError(error);
    }
  }

  async createPost(
    decodedAccessToken: IDecodedAccecssTokenType,
    data: CreatePostDto,
  ): Promise<IResponseType<PostDataType>> {
    try {
      // eslint-disable-next-line @typescript-eslint/no-unused-vars
      const { images: imagesData, mentionedUserIds, ...postData } = data;
      const { userId } = decodedAccessToken;
      const [, post] = await this.prisma.$transaction([
        this.prisma.user.update({
          where: { id: userId },
          data: {
            credits: {
              increment: 0.2,
            },
            postCount: {
              increment: 1,
            },
          },
        }),
        this.prisma.post.create({
          data: {
            ...postData,
            authorId: userId,
          },
          select: postDataSelect,
        }),
      ]);
      let images = [];
      if (data.images) {
        images = await this.s3Service.uploadPostImages({
          files: data.images,
          names: data.images.map((image) => image.originalname),
          userId,
          postId: post.id,
        });
      }

      // Handle mention notifications (only for public posts)
      if (mentionedUserIds && mentionedUserIds.length > 0 && !post.isPrivate) {
        // Filter out self-mentions and get unique user IDs
        const uniqueMentionedUserIds = [
          ...new Set(mentionedUserIds.filter((id) => id !== userId)),
        ];

        // Create mention notifications for all mentioned users
        const mentionPromises = uniqueMentionedUserIds.map((mentionedUserId) =>
          this.notificationService.createPostMentionNotification({
            senderId: userId,
            recipientId: mentionedUserId,
            postId: post.id,
            senderData: {
              username: post.author.username,
              fullName: post.author.fullName,
              avatar: post.author.avatar,
            } as any, // Type cast since we only need these fields
          }),
        );

        await Promise.allSettled(mentionPromises);
      }

      // Emit new post to all connected clients
      if (!post.isPrivate) {
        this.postGateway.emitNewPost(post);
      }

      return {
        message: 'Post created successfully',
        data: { ...post, media: images },
        statusCode: 201,
        date: new Date(),
      };
    } catch (error) {
      handleDefaultError(error);
    }
  }

  /**
   * Share (repost) an existing post.
   *
   * Creates a new post owned by the current user that references the original
   * via `sharedPostId`. Sharing a post that is itself a share collapses to the
   * root original (no share-of-share chains). The original's `shareCount` is
   * incremented and the original author receives a SHARE_POST notification.
   */
  async sharePost({
    postId,
    decodedAccessToken,
    content = '',
    isPrivate = false,
    mentionedUserIds,
  }: {
    postId: string;
    decodedAccessToken: IDecodedAccecssTokenType;
    content?: string;
    isPrivate?: boolean;
    mentionedUserIds?: string[];
  }): Promise<IResponseType<PostDataType>> {
    try {
      if (!postId) {
        throw new BadRequestException('Post id is required');
      }

      const { userId } = decodedAccessToken;

      const clicked = await this.prisma.post.findUnique({
        where: { id: postId },
        select: {
          id: true,
          isPrivate: true,
          authorId: true,
          sharedPostId: true,
        },
      });

      if (!clicked) {
        throw new NotFoundException('Post not found');
      }

      // Collapse share-of-share to the root original.
      const targetId = clicked.sharedPostId ?? clicked.id;
      const target = clicked.sharedPostId
        ? await this.prisma.post.findUnique({
            where: { id: targetId },
            select: { id: true, isPrivate: true, authorId: true },
          })
        : clicked;

      if (!target) {
        throw new NotFoundException('Original post not found');
      }

      // A private post can only be shared by its own author.
      if (target.isPrivate && target.authorId !== userId) {
        throw new ForbiddenException('You cannot share a private post');
      }

      const [, , sharePost] = await this.prisma.$transaction([
        this.prisma.user.update({
          where: { id: userId },
          data: {
            credits: { increment: 0.2 },
            postCount: { increment: 1 },
          },
        }),
        this.prisma.post.update({
          where: { id: targetId },
          data: { shareCount: { increment: 1 } },
          select: null,
        }),
        this.prisma.post.create({
          data: {
            content,
            isPrivate,
            authorId: userId,
            sharedPostId: targetId,
          },
          select: postDataSelect,
        }),
      ]);

      // Notify the original author (skip self-share).
      if (target.authorId !== userId) {
        const senderData = await this.prisma.user.findUnique({
          where: { id: userId },
          select: userDataSelect,
        });

        if (senderData) {
          await this.notificationService.createSharePostNotification({
            recipientId: target.authorId,
            senderId: userId,
            postId: targetId,
            sharePostId: sharePost.id,
            senderData,
          });
        }
      }

      // Handle mention notifications from the share caption (public shares only).
      if (
        mentionedUserIds &&
        mentionedUserIds.length > 0 &&
        !sharePost.isPrivate
      ) {
        const uniqueMentionedUserIds = [
          ...new Set(mentionedUserIds.filter((id) => id !== userId)),
        ];

        const mentionPromises = uniqueMentionedUserIds.map((mentionedUserId) =>
          this.notificationService.createPostMentionNotification({
            senderId: userId,
            recipientId: mentionedUserId,
            postId: sharePost.id,
            senderData: {
              username: sharePost.author.username,
              fullName: sharePost.author.fullName,
              avatar: sharePost.author.avatar,
            } as any,
          }),
        );

        await Promise.allSettled(mentionPromises);
      }

      // Surface the new share post in realtime feeds (public only).
      if (!sharePost.isPrivate) {
        this.postGateway.emitNewPost(sharePost);
      }

      return {
        message: 'Post shared successfully',
        data: sharePost,
        statusCode: 201,
        date: new Date(),
      };
    } catch (error) {
      handleDefaultError(error);
    }
  }

  /**
   * Toggle / change a reaction on a post for the current user.
   *
   * Behavior matrix:
   *   - no existing reaction              -> create new with `type`, +1 likeCount
   *   - existing reaction same as `type`  -> remove (toggle off), -1 likeCount
   *   - existing reaction different type  -> swap to `type`, likeCount unchanged
   *
   * `likeCount` is the total reaction count (kept as-is for backward compat
   * with existing UI/columns).
   */
  async likePost({
    postId,
    decodedAccessToken,
    type = 'LIKE',
  }: {
    postId: string;
    decodedAccessToken: IDecodedAccecssTokenType;
    type?: ReactionType;
  }): Promise<IResponseType<PostDataTypeWithLikeStatus>> {
    try {
      if (!postId) {
        throw new BadRequestException({
          message: 'Post id is required',
          statusCode: 400,
          date: new Date(),
        });
      }

      const post = await this.prisma.post.findUnique({
        where: { id: postId },
        select: {
          ...postDataSelect,
          likes: {
            where: {
              userId: decodedAccessToken.userId,
            },
            select: {
              id: true,
              type: true,
            },
          },
        },
      });

      if (!post) {
        throw new NotFoundException({
          message: 'Post not found',
          statusCode: 404,
          date: new Date(),
        });
      }

      const existing = post.likes[0];
      const isSameTypeToggle = existing?.type === type;
      const isSwap = existing && existing.type !== type;
      const isAdd = !existing;

      // 1) Apply reaction change
      if (isAdd) {
        await this.prisma.postLike.create({
          data: {
            postId,
            userId: decodedAccessToken.userId,
            type,
          },
        });
      } else if (isSameTypeToggle) {
        await this.prisma.postLike.deleteMany({
          where: {
            postId,
            userId: decodedAccessToken.userId,
          },
        });
      } else if (isSwap) {
        await this.prisma.postLike.updateMany({
          where: {
            postId,
            userId: decodedAccessToken.userId,
          },
          data: { type },
        });
      }

      // 2) Adjust the post's total reaction count (only on add/remove)
      const updatedPost = await this.prisma.post.update({
        where: { id: postId },
        data: isAdd
          ? { likeCount: { increment: 1 } }
          : isSameTypeToggle
            ? { likeCount: { decrement: 1 } }
            : {},
        select: postDataSelect,
      });

      // 3) Notification side-effect: create on add, delete on toggle-off, no-op on swap
      if (isAdd && post.author.id !== decodedAccessToken.userId) {
        const senderData = await this.prisma.user.findUnique({
          where: { id: decodedAccessToken.userId },
          select: userDataSelect,
        });

        if (senderData) {
          await this.notificationService.createLikePostNotification({
            recipientId: post.author.id,
            senderId: decodedAccessToken.userId,
            postId,
            senderData,
          });
        }
      } else if (isSameTypeToggle) {
        await this.notificationService.deleteLikePostNotification({
          recipientId: post.author.id,
          senderId: decodedAccessToken.userId,
          postId,
        });
      }

      const reactionCounts = await this.getReactionCountsByPostId(postId);
      const myReaction: ReactionType | null = isSameTypeToggle ? null : type;

      return {
        message: 'Post reaction updated successfully',
        data: {
          ...updatedPost,
          isLiked: !!myReaction,
          myReaction,
          reactionCounts,
        },
        statusCode: 200,
        date: new Date(),
      };
    } catch (error) {
      handleDefaultError(error);
    }
  }

  /**
   * Toggle bookmark (save/unsave) a post for the current user.
   */
  async toggleBookmark({
    postId,
    userId,
  }: {
    postId: string;
    userId: string;
  }): Promise<IResponseType<PostDataTypeWithLikeStatus>> {
    try {
      if (!postId) {
        throw new BadRequestException('Post id is required');
      }

      const post = await this.prisma.post.findUnique({
        where: { id: postId },
        select: {
          ...postDataSelect,
          likes: {
            where: { userId },
            select: { userId: true, type: true },
          },
          bookmarks: {
            where: { userId },
            select: { id: true },
          },
        },
      });

      if (!post) {
        throw new NotFoundException('Post not found');
      }

      const existingBookmark = post.bookmarks[0];

      if (existingBookmark) {
        await this.prisma.bookmark.delete({
          where: { id: existingBookmark.id },
        });
      } else {
        await this.prisma.bookmark.create({ data: { postId, userId } });
      }

      const reactionCounts = await this.getReactionCountsByPostId(post.id);

      // eslint-disable-next-line @typescript-eslint/no-unused-vars
      const { likes, bookmarks, ...postData } = post;

      return {
        message: existingBookmark
          ? 'Post removed from bookmarks'
          : 'Post bookmarked successfully',
        data: {
          ...postData,
          isLiked: likes.length > 0,
          myReaction:
            (likes[0] as { type?: ReactionType } | undefined)?.type ?? null,
          reactionCounts,
          isBookmarked: !existingBookmark,
        },
        statusCode: 200,
        date: new Date(),
      };
    } catch (error) {
      handleDefaultError(error);
    }
  }

  /**
   * Get the current user's bookmarked posts (most recent first).
   */
  async getMyBookmarks({
    userId,
    limit,
    page,
  }: {
    userId: string;
    limit: number;
    page: number;
  }): Promise<IPaginationResponseType<PostDataTypeWithLikeStatus>> {
    try {
      const blockedUserIds = await this.getBlockedUserIds(userId);

      const whereQuery: Prisma.BookmarkWhereInput = {
        userId,
        post: {
          // Respect private-post access control: a private post stays visible
          // only to its author, even if someone bookmarked it earlier.
          OR: [{ isPrivate: false }, { authorId: userId }],
          ...(blockedUserIds.length
            ? { NOT: { authorId: { in: blockedUserIds } } }
            : {}),
        },
      };

      const [totalCount, bookmarks] = await this.prisma.$transaction([
        this.prisma.bookmark.count({ where: whereQuery }),
        this.prisma.bookmark.findMany({
          where: whereQuery,
          take: limit,
          skip: (page - 1) * limit,
          orderBy: { createdAt: 'desc' },
          select: {
            post: {
              select: {
                ...postDataSelect,
                likes: {
                  where: { userId },
                  select: { userId: true, type: true },
                },
              },
            },
          },
        }),
      ]);

      const posts = bookmarks
        .map((bookmark) => bookmark.post)
        .filter((post): post is NonNullable<typeof post> => !!post);

      const reactionCountsByPost = await this.getReactionCountsByPostIds(
        posts.map((post) => post.id),
      );

      const items = posts.map(({ likes, ...post }) => ({
        ...post,
        isLiked: likes.length > 0,
        myReaction:
          (likes[0] as { type?: ReactionType } | undefined)?.type ?? null,
        reactionCounts:
          reactionCountsByPost.get(post.id) ?? this.buildEmptyReactionCounts(),
        isBookmarked: true,
      }));

      const totalPage = Math.ceil(totalCount / limit);
      const hasNextPage = page * limit < totalCount;
      const hasPreviousPage = !!totalCount && page > 1;

      return {
        message: 'Bookmarks fetched successfully',
        data: {
          totalCount,
          totalPage,
          currentPage: page,
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

  async aiGeneratePost({
    data,
    decodedAccessToken,
  }: {
    data: { prompt: string };
    decodedAccessToken: IDecodedAccecssTokenType;
  }): Promise<
    IResponseType<
      IBaseResponseAIType & {
        content: string;
      }
    >
  > {
    try {
      const price = 1;

      const user = await this.prisma.user.findUnique({
        where: {
          id: decodedAccessToken.userId,
        },
        select: {
          credits: true,
        },
      });

      if (user.credits.lte(price)) {
        throw new BadRequestException({
          message: 'Not enough credits',
          price: 0,
          currentCredits: user.credits,
          date: new Date(),
        });
      }

      const completion = await openai.chat.completions.create({
        model: 'openai/gpt-4o-mini',
        messages: [
          ...POST_AI_PROMPTS.GENERATE_BLOG_POST,
          { role: 'user', content: data.prompt },
        ],
      });
      const resultContent = completion.choices[0].message.content
        .replaceAll('\n', '<br>')
        .replaceAll(/\\"/g, '"');

      if (resultContent === blockResultMessage)
        throw new BadRequestException({
          message: blockResultMessage,
          price: `0 credits`,
          priceNum: 0,
          currentCredits: user.credits,
          statusCode: 400,
          date: new Date(),
        });

      const updateUser = await this.prisma.user.update({
        where: {
          id: decodedAccessToken.userId,
        },
        data: {
          credits: {
            decrement: price,
          },
        },
        select: {
          credits: true,
        },
      });

      return {
        message: 'AI generated a post successfully',
        data: {
          price: `${price} credits`,
          priceNum: price,
          currentCredits: updateUser.credits,
          content: resultContent,
        },
        statusCode: 200,
        date: new Date(),
      };
    } catch (error) {
      handleDefaultError(error);
    }
  }

  async updatePost({
    postId,
    data,
    decodedAccessToken,
  }: {
    postId: string;
    data: UpdatePostDto;
    decodedAccessToken: IDecodedAccecssTokenType;
  }) {
    try {
      if (!postId) {
        throw new BadRequestException('Post id is required');
      }

      const { userId } = decodedAccessToken;

      Object.keys(data).forEach((key) => {
        if (!data[key]) {
          if (typeof data[key] === 'boolean') {
            data[key] = data[key] ?? false;
            return;
          }
          data[key] = undefined;
        }
      });

      const checkUser = await this.prisma.user.findUnique({
        where: {
          id: userId,
        },
      });

      if (!checkUser) throw new NotFoundException('User not found');

      const checkPost = await this.prisma.post.findUnique({
        where: {
          id: postId,
        },
      });
      if (!checkPost) throw new NotFoundException('Post not found');
      if (checkPost.authorId !== userId)
        throw new ForbiddenException('Unauthorized');

      const updatedPost = await this.prisma.post.update({
        where: {
          id: postId,
        },
        data,
        select: postDataSelect,
      });

      return {
        message: 'Post updated successfully',
        data: updatedPost,
        statusCode: 200,
        date: new Date(),
      };
    } catch (error) {
      handleDefaultError(error);
    }
  }

  async updatePostAsAdmin({
    postId,
    data,
  }: {
    postId: string;
    data: UpdatePostAsAdminDto;
  }): Promise<IResponseType<PostDataType>> {
    try {
      if (!postId) {
        throw new BadRequestException('Post id is required');
      }

      Object.keys(data).forEach((key) => {
        if (!data[key]) {
          if (typeof data[key] === 'boolean') {
            data[key] = data[key] ?? false;
            return;
          }
          data[key] = undefined;
        }
      });
      const updatedPost = await this.prisma.post.update({
        where: {
          id: postId,
        },
        data,
        select: postDataSelect,
      });
      if (!updatedPost) throw new NotFoundException('Post not found');

      return {
        message: 'Post updated successfully',
        data: updatedPost,
        statusCode: 200,
        date: new Date(),
      };
    } catch (error) {
      handleDefaultError(error);
    }
  }

  /**
   * Handle deleting a post and updating associated user data
   * @param postId - ID of the post to delete
   * @param userId - Optional ID of user making the delete request
   * @returns Response object with delete status
   */
  private async handleDeletePost(
    postId: string,
    userId?: string,
  ): Promise<IResponseType<PostDataType>> {
    // Find the post and get its author ID
    const post = await this.prisma.post.findUnique({
      where: { id: postId },
      select: { authorId: true, sharedPostId: true },
    });

    if (!post) {
      throw new NotFoundException('Post not found');
    }

    // Delete post images
    await this.s3Service.deletePostImages({ postId });

    // Delete all notifications related to this post
    await this.notificationService.deletePostRelatedNotifications(postId);

    // If this post is a share, decrement the original's shareCount and remove
    // the share notification sent to the original author.
    const sharedDecrement = post.sharedPostId
      ? [
          this.prisma.post.update({
            where: { id: post.sharedPostId },
            data: { shareCount: { decrement: 1 } },
          }),
        ]
      : [];

    const cleanupShareNotification = async (sharerId: string) => {
      if (!post.sharedPostId) return;
      const original = await this.prisma.post.findUnique({
        where: { id: post.sharedPostId },
        select: { authorId: true },
      });
      if (original && original.authorId !== sharerId) {
        await this.notificationService.deleteSharePostNotification({
          recipientId: original.authorId,
          senderId: sharerId,
          sharePostId: postId,
        });
      }
    };

    if (userId) {
      // If userId provided, verify user exists and has permission
      const user = await this.prisma.user.findUnique({
        where: { id: userId },
      });

      if (!user) {
        throw new NotFoundException('User not found');
      }

      if (post.authorId !== userId) {
        throw new ForbiddenException('This post is not yours');
      }

      // Delete post and decrement user's post count in a transaction
      const ops = [
        this.prisma.user.update({
          where: { id: userId },
          data: { postCount: { decrement: 1 } },
        }),
        ...sharedDecrement,
        this.prisma.post.delete({
          where: { id: postId },
          select: postDataSelect,
        }),
      ];
      const results = await this.prisma.$transaction(ops);
      const deletedPost = results[
        results.length - 1
      ] as unknown as PostDataType;

      await cleanupShareNotification(post.authorId);

      return {
        message: 'Post deleted successfully',
        data: deletedPost,
        statusCode: 200,
        date: new Date(),
      };
    }

    // Delete post and decrement user's post count in a transaction
    const ops = [
      this.prisma.user.update({
        where: { id: post.authorId },
        data: { postCount: { decrement: 1 } },
      }),
      ...sharedDecrement,
      this.prisma.post.delete({
        where: { id: postId },
        select: postDataSelect,
      }),
    ];
    const results = await this.prisma.$transaction(ops);
    const deletedPost = results[results.length - 1] as unknown as PostDataType;

    await cleanupShareNotification(post.authorId);

    return {
      message: 'Post deleted successfully',
      data: deletedPost,
      statusCode: 200,
      date: new Date(),
    };
  }

  async handleDeletePosts(postIds: UUID[]): Promise<
    IBeforeTransformResponseType<
      {
        postId: string;
      }[]
    >
  > {
    const posts = await this.prisma.post.findMany({
      where: { id: { in: postIds } },
      select: { authorId: true },
    });

    if (posts.length === 0) {
      return {
        type: 'response',
        message: 'Delete posts successfully',
        data: [],
      };
    }

    // Delete post images
    postIds.map((postId) => this.s3Service.deletePostImages({ postId }));

    // Delete all notifications related to this post
    const deleteNotificationsPromises = postIds.map((postId) =>
      this.notificationService.deletePostRelatedNotifications(postId),
    );
    await Promise.all(deleteNotificationsPromises);

    // Delete post and decrement user's post count in a transaction
    const [] = await this.prisma.$transaction([
      this.prisma.user.updateMany({
        where: {
          id: {
            in: posts.map((post) => post.authorId),
          },
        },
        data: { postCount: { decrement: 1 } },
      }),
      this.prisma.post.deleteMany({
        where: { id: { in: postIds } },
      }),
    ]);

    const result = postIds.map((postId) => ({
      postId,
    }));

    return {
      type: 'response',
      message: 'Post deleted successfully',
      data: result,
      statusCode: 200,
    };
  }

  async deletePost({ postId, decodedAccessToken }) {
    try {
      return await this.handleDeletePost(postId, decodedAccessToken.userId);
    } catch (error) {
      handleDefaultError(error);
    }
  }

  async deletePostAsAdmin({
    postId,
  }: {
    postId: string;
  }): Promise<IResponseType<PostDataType>> {
    try {
      return await this.handleDeletePost(postId);
    } catch (error) {
      handleDefaultError(error);
    }
  }

  handleCalculatePriceGenerateImages = (data: GenerateImagesDto) => {
    const pricePerImage = 1; // 1 credit per image
    const { numImages, steps } = data;
    const stepsPrice = Math.ceil(steps / 10); // 10 steps = 1 credit

    return pricePerImage * numImages * stepsPrice;
  };

  async handleGenerateImages({
    data,
  }: {
    data: GenerateImagesDto;
  }): Promise<IGenerateImagesResponseType> {
    try {
      const validatedData = generateImagesSchema.parse(data);

      const { prompt, numImages, imageSize, seed } = validatedData;

      const processedSeed =
        seed === -1 ? Math.floor(Math.random() * 2147483647) : seed;

      const processedImageSize = {
        width: Number(imageSize.split('x')[0]),
        height: Number(imageSize.split('x')[1]),
      };

      const options: AxiosRequestConfig = {
        method: 'POST',
        url: 'https://api.thehive.ai/api/v3/hive/flux-schnell-enhanced',
        headers: {
          accept: 'application/json',
          Authorization: `Bearer ${this.configService.get('THEHIVE_API_KEY')}`,
          'Content-Type': 'application/json',
        },
        data: {
          input: {
            prompt,
            num_images: numImages,
            image_size: processedImageSize,
            seed: processedSeed,
            output_format: 'png',
          },
        },
      };

      const { data: responseData } = await axios(options);

      return responseData;
    } catch (error) {
      handleDefaultError(error);
    }
  }

  async getPriceGenerateImages(
    data: GenerateImagesDto,
  ): Promise<IBeforeTransformResponseType<{ price: number }>> {
    const price = this.handleCalculatePriceGenerateImages(data);
    return {
      type: 'response',
      message: 'Price fetched successfully',
      data: { price },
    };
  }

  async aiGenerateImages({
    userId,
    data,
  }: {
    userId: string;
    data: GenerateImagesDto;
  }): Promise<
    IBeforeTransformResponseType<
      IBaseResponseAIType & {
        data: IGenerateImagesResponseType;
      }
    >
  > {
    try {
      const user = await this.userService.validateUser({
        userId,
        selectData: {
          id: true,
          credits: true,
        },
      });

      const price = this.handleCalculatePriceGenerateImages(data);
      if (user.credits.toNumber() < price) {
        throw new BadRequestException('Insufficient credits');
      }

      const updatedUser = await this.prisma.user.update({
        where: { id: userId },
        data: {
          credits: {
            decrement: price,
          },
        },
        select: {
          credits: true,
        },
      });

      const responseData = await this.handleGenerateImages({ data });

      const images = await this.s3Service.uploadFilesFromUrls(
        responseData.output.map((img) => img.url),
        responseData.output.map((_, index) => `ai-image-${index}.png`),
        userId,
      );

      return {
        type: 'response',
        message: 'Images generated successfully',
        data: {
          price: `${price} credits`,
          priceNum: price,
          currentCredits: updatedUser.credits,
          data: {
            ...responseData,
            output: images.map((img) => ({ url: img.url })),
          },
        },
      };
    } catch (error) {
      handleDefaultError(error);
    }
  }
}
