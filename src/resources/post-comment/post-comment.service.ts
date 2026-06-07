import {
  BadRequestException,
  ForbiddenException,
  Injectable,
  NotFoundException,
} from '@nestjs/common';
import { Prisma, ReactionType } from '@prisma/client';
import { handleDefaultError } from 'src/global/functions.global';
import {
  IBeforeTransformResponseType,
  IPaginationResponseType,
  IResponseType,
} from 'src/interfaces/interfaces.global';
import {
  postCommentDataSelect,
  PostCommentDataType,
  PostCommentDataTypeWithLikeStatus,
  PostCommentLikeDataType,
  PostCommentReactionCounts,
  postDataSelect,
  PostDataType,
  userDataSelect,
} from 'src/libs/prisma-types';
import { PrismaService } from 'src/prisma/prisma.service';
import { CommentGateway } from 'src/resources/gateways/comment/comment.gateway';
import { NotificationService } from 'src/resources/notification/notification.service';
import {
  CreatePostCommentDto,
  UpdatePostCommentDto,
} from 'src/resources/post-comment/dto/post-copmment.dto';
import { PostService } from 'src/resources/post/post.service';

@Injectable()
export class PostCommentService {
  constructor(
    // private readonly postService: PostService,
    private readonly prisma: PrismaService,
    private readonly postService: PostService,
    private readonly commentGateway: CommentGateway,
    private readonly notification: NotificationService,
  ) {}

  async getCommentCount(): Promise<
    IBeforeTransformResponseType<{
      totalCommentsCount: number;
    }>
  > {
    try {
      const count = await this.prisma.postComment.count();
      return {
        type: 'response',
        message: 'Comment count fetched successfully',
        data: {
          totalCommentsCount: count,
        },
      };
    } catch (error) {
      handleDefaultError(error);
    }
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
  private buildEmptyReactionCounts(): PostCommentReactionCounts {
    return PostCommentService.REACTION_TYPES.reduce((acc, type) => {
      acc[type] = 0;
      return acc;
    }, {} as PostCommentReactionCounts);
  }

  /**
   * Aggregate reaction counts (per `ReactionType`) for the given comments in a
   * single grouped query - avoids N+1 when listing comment threads.
   * Returns a map: `commentId -> PostCommentReactionCounts`.
   */
  private async getReactionCountsByCommentIds(
    commentIds: string[],
  ): Promise<Map<string, PostCommentReactionCounts>> {
    const result = new Map<string, PostCommentReactionCounts>();
    if (commentIds.length === 0) return result;

    const groups = await this.prisma.postCommentLike.groupBy({
      by: ['commentId', 'type'],
      where: { commentId: { in: commentIds } },
      _count: { _all: true },
    });

    for (const { commentId, type, _count } of groups) {
      const counts = result.get(commentId) ?? this.buildEmptyReactionCounts();
      counts[type] = _count._all;
      result.set(commentId, counts);
    }

    return result;
  }

  /** Convenience for a single comment id. */
  private async getReactionCountsByCommentId(
    commentId: string,
  ): Promise<PostCommentReactionCounts> {
    const map = await this.getReactionCountsByCommentIds([commentId]);
    return map.get(commentId) ?? this.buildEmptyReactionCounts();
  }

  /**
   * Toggle / change a reaction on a comment for the current user.
   *
   * Behavior matrix mirrors `PostService.likePost`:
   *   - no existing reaction              -> create new with `type`, +1 likeCount
   *   - existing reaction same as `type`  -> remove (toggle off), -1 likeCount
   *   - existing reaction different type  -> swap to `type`, likeCount unchanged
   */
  async likeComment({
    commentId,
    userId,
    type = 'LIKE',
  }: {
    commentId: string;
    userId: string;
    type?: ReactionType;
  }): Promise<IResponseType<PostCommentDataTypeWithLikeStatus>> {
    try {
      if (!commentId) {
        throw new BadRequestException('Comment id is required');
      }

      const comment = await this.prisma.postComment.findUnique({
        where: { id: commentId },
        select: {
          ...postCommentDataSelect,
          likes: {
            where: { userId },
            select: {
              id: true,
              type: true,
            },
          },
        },
      });

      if (!comment) {
        throw new NotFoundException('Comment not found');
      }

      const existing = comment.likes[0];
      const isSameTypeToggle = existing?.type === type;
      const isSwap = existing && existing.type !== type;
      const isAdd = !existing;

      // 1) Apply reaction change
      if (isAdd) {
        await this.prisma.postCommentLike.create({
          data: {
            commentId,
            userId,
            type,
          },
        });
      } else if (isSameTypeToggle) {
        await this.prisma.postCommentLike.deleteMany({
          where: { commentId, userId },
        });
      } else if (isSwap) {
        await this.prisma.postCommentLike.updateMany({
          where: { commentId, userId },
          data: { type },
        });
      }

      // 2) Adjust the comment's total reaction count (only on add/remove)
      const updatedComment = await this.prisma.postComment.update({
        where: { id: commentId },
        data: isAdd
          ? { likeCount: { increment: 1 } }
          : isSameTypeToggle
            ? { likeCount: { decrement: 1 } }
            : {},
        select: postCommentDataSelect,
      });

      // 3) Notification side-effect: create on add, delete on toggle-off, no-op on swap
      if (isAdd && comment.author.id !== userId) {
        const senderData = await this.prisma.user.findUnique({
          where: { id: userId },
          select: userDataSelect,
        });

        if (senderData) {
          await this.notification.createLikeCommentNotification({
            recipientId: comment.author.id,
            senderId: userId,
            postId: comment.post.id,
            commentId,
            senderData,
          });
        }
      } else if (isSameTypeToggle) {
        await this.notification.deleteLikeCommentNotification({
          recipientId: comment.author.id,
          senderId: userId,
          postId: comment.post.id,
          commentId,
        });
      }

      const reactionCounts = await this.getReactionCountsByCommentId(commentId);
      const myReaction: ReactionType | null = isSameTypeToggle ? null : type;

      return {
        message: 'Comment reaction updated successfully',
        data: {
          ...updatedComment,
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

  async getCommentLikes({
    commentId,
    page,
    limit,
    userId,
    type,
  }: {
    commentId: string;
    page: number;
    limit: number;
    userId?: string;
    type?: ReactionType;
  }): Promise<
    IPaginationResponseType<PostCommentLikeDataType> & {
      data: { comment: PostCommentDataType };
    }
  > {
    try {
      if (!commentId) {
        throw new BadRequestException('Comment id is required');
      }

      const comment = await this.prisma.postComment.findUnique({
        where: { id: commentId },
        select: postCommentDataSelect,
      });
      if (!comment) {
        throw new NotFoundException('Comment not found');
      }

      const whereQuery: Prisma.PostCommentLikeWhereInput = {
        commentId,
        ...(userId ? { userId } : {}),
        ...(type ? { type } : {}),
      };

      const [likes, totalCount] = await this.prisma.$transaction([
        this.prisma.postCommentLike.findMany({
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
        this.prisma.postCommentLike.count({
          where: whereQuery,
        }),
      ]);

      const totalPage = Math.ceil(totalCount / limit);
      const hasNextPage = page * limit < totalCount;
      const hasPreviousPage = !!totalCount && page > 1;

      return {
        message: 'Comment likes fetched successfully',
        data: {
          comment,
          items: likes,
          currentPage: page,
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

  async createPostComment({
    authorId,
    postId,
    data,
  }: {
    authorId: string;
    postId: string;
    data: CreatePostCommentDto;
  }): Promise<IResponseType<PostCommentDataType>> {
    try {
      const post = await this.postService.validatePost(postId);

      const MAX_COMMENT_LEVEL = 2;

      const { content, replyToId, mentionedUserIds } = data;

      const parentComment =
        replyToId &&
        (await this.prisma.postComment.findUnique({
          where: {
            id: replyToId,
          },
          select: {
            id: true,
            level: true,
            replyToId: true,
            authorId: true,
          },
        }));
      if (replyToId && !parentComment) {
        throw new NotFoundException('Comment you are replying to not found');
      }

      // Simplified level and replyToId calculation
      const level = !replyToId ? 0 : parentComment.level + 1;
      const validLevel = Math.min(level, MAX_COMMENT_LEVEL);

      const validReplyToId = replyToId
        ? level > MAX_COMMENT_LEVEL
          ? parentComment.replyToId
          : level <= MAX_COMMENT_LEVEL && replyToId
        : null;

      const [, createdComment] = await this.prisma.$transaction([
        this.prisma.post.update({
          where: { id: postId },
          data: { commentCount: { increment: 1 } },
          select: null,
        }),
        this.prisma.postComment.create({
          data: {
            content,
            replyToId: validReplyToId,
            postId,
            authorId,
            level: validLevel,
          },
          select: postCommentDataSelect,
        }),
        ...(validReplyToId
          ? [
              this.prisma.postComment.update({
                where: { id: validReplyToId },
                data: { repliesCount: { increment: 1 } },
                select: null,
              }),
            ]
          : []),
      ]);

      // Create notification for post author (only for root comments, not replies)
      // Also skip if the commenter is the post author themselves
      const isRootComment = !parentComment;
      const isNotPostAuthor = authorId !== post.author.id;

      if (isRootComment && isNotPostAuthor) {
        await this.notification.createCommentNotification({
          postId,
          commentId: createdComment.id,
          senderId: authorId,
          recipientId: post.author.id,
          senderData: createdComment.author,
        });
      }

      // Create notification for parent comment author (for reply comments)
      // Skip if replying to own comment
      if (parentComment && authorId !== parentComment.authorId) {
        await this.notification.createReplyCommentNotification({
          postId,
          commentId: createdComment.id,
          replyCommentId: validReplyToId,
          senderId: authorId,
          recipientId: parentComment.authorId,
          senderData: createdComment.author,
        });
      }

      // Handle mention notifications
      if (mentionedUserIds && mentionedUserIds.length > 0) {
        // Filter out self-mentions and get unique user IDs
        const uniqueMentionedUserIds = [
          ...new Set(mentionedUserIds.filter((id) => id !== authorId)),
        ];

        // Create mention notifications for all mentioned users
        const mentionPromises = uniqueMentionedUserIds.map((mentionedUserId) =>
          this.notification.createCommentMentionNotification({
            senderId: authorId,
            recipientId: mentionedUserId,
            postId,
            commentId: createdComment.id,
            senderData: {
              username: createdComment.author.username,
              fullName: createdComment.author.fullName,
              avatar: createdComment.author.avatar,
            } as any,
          }),
        );

        await Promise.all(mentionPromises);
      }

      // Emit new comment to all connected clients
      this.commentGateway.emitNewComment(createdComment);

      return {
        message: 'Comment created successfully',
        data: createdComment,
        statusCode: 201,
        date: new Date(),
      };
    } catch (error) {
      handleDefaultError(error);
    }
  }

  async getPostComments({
    postId,
    page = 1,
    limit = 10,
    replyTo,
    likeUserId,
  }: {
    postId: string;
    page: number;
    limit: number;
    replyTo: string;
    likeUserId?: string;
  }): Promise<IPaginationResponseType<PostCommentDataTypeWithLikeStatus>> {
    try {
      if (!postId) {
        throw new BadRequestException('Post id is required');
      }

      const postExist = await this.prisma.post.findUnique({
        where: {
          id: postId,
        },
        select: {
          id: true,
        },
      });
      if (!postExist) {
        throw new NotFoundException('Post not found');
      }

      const whereQuery: Prisma.PostCommentWhereInput = {
        postId,
        replyToId: replyTo || null,
      };

      const [comments, totalCount] = await this.prisma.$transaction([
        this.prisma.postComment.findMany({
          where: whereQuery,
          orderBy: { createdAt: 'asc' },
          skip: (page - 1) * limit,
          take: limit,
          select: {
            ...postCommentDataSelect,
            likes: {
              where: {
                userId: likeUserId || '',
              },
              select: {
                userId: true,
                type: true,
              },
            },
          },
        }),
        this.prisma.postComment.count({
          where: whereQuery,
        }),
      ]);

      const reactionCountsByComment = await this.getReactionCountsByCommentIds(
        comments.map((c) => c.id),
      );

      const items: PostCommentDataTypeWithLikeStatus[] = comments.map(
        ({ likes, ...comment }) => ({
          ...comment,
          isLiked: likes.length > 0,
          myReaction: likes[0]?.type ?? null,
          reactionCounts:
            reactionCountsByComment.get(comment.id) ??
            this.buildEmptyReactionCounts(),
        }),
      );

      const totalPage = Math.ceil(totalCount / limit);
      const hasNextPage = page * limit < totalCount;
      const hasPreviousPage = !!totalCount && page > 1;

      return {
        message: 'Get comments successfully',
        data: {
          currentPage: page,
          pageSize: limit,
          totalPage,
          totalCount,
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

  async handleUpdatePostComment({
    commentId,
    data,
    authorId,
  }: {
    commentId: string;
    data: UpdatePostCommentDto;
    authorId?: string;
  }): Promise<{ updatedComment: PostCommentDataType }> {
    try {
      if (!commentId) {
        throw new BadRequestException('Comment id is required');
      }

      const commentExist = await this.prisma.postComment.findUnique({
        where: { id: commentId },
        select: { id: true, authorId: true },
      });
      if (!commentExist) {
        throw new NotFoundException('Comment not found');
      }

      if (authorId && commentExist.authorId !== authorId) {
        throw new ForbiddenException('This comment is not yours');
      }

      const updatedComment = await this.prisma.postComment.update({
        where: { id: commentId },
        data: { content: data.content },
        select: postCommentDataSelect,
      });
      return { updatedComment };
    } catch (error) {
      handleDefaultError(error);
    }
  }

  async updatePostComment({
    commentId,
    data,
    authorId,
  }: {
    commentId: string;
    data: UpdatePostCommentDto;
    authorId?: string;
  }): Promise<IResponseType<PostCommentDataType>> {
    const { updatedComment } = await this.handleUpdatePostComment({
      commentId,
      data,
      authorId,
    });
    return {
      message: 'Comment updated successfully',
      data: updatedComment,
      statusCode: 201,
      date: new Date(),
    };
  }

  async updatePostCommentByAdmin({
    commentId,
    data,
  }: {
    commentId: string;
    data: UpdatePostCommentDto;
  }): Promise<IResponseType<PostCommentDataType>> {
    const { updatedComment } = await this.handleUpdatePostComment({
      commentId,
      data,
    });
    return {
      message: 'Comment updated successfully',
      data: updatedComment,
      statusCode: 201,
      date: new Date(),
    };
  }

  async handleDeletePostComment({
    commentId,
    authorId,
  }: {
    commentId: string;
    authorId?: string;
  }): Promise<{ deletedComment: PostCommentDataType }> {
    try {
      if (!commentId) {
        throw new BadRequestException('Comment id is required');
      }

      const commentExist = await this.prisma.postComment.findUnique({
        where: { id: commentId },
        select: {
          id: true,
          postId: true,
          authorId: true,
          replyToId: true,
          post: {
            select: {
              commentCount: true,
              authorId: true,
            },
          },
          // Get parent comment author to delete reply notification
          replyTo: {
            select: {
              authorId: true,
            },
          },
        },
      });

      if (!commentExist) {
        throw new NotFoundException('Comment not found');
      }

      if (authorId && commentExist.authorId !== authorId) {
        throw new ForbiddenException('This comment is not yours');
      }

      // Combine all operations in a single transaction
      const [, deletedComment] = await this.prisma.$transaction([
        this.prisma.post.update({
          where: { id: commentExist.postId },
          data: {
            commentCount: {
              decrement: commentExist.post.commentCount > 0 ? 1 : 0,
            },
          },
        }),

        this.prisma.postComment.delete({
          where: { id: commentExist.id },
          select: postCommentDataSelect,
        }),

        // Update parent comment's replies count if this is a reply
        ...(commentExist.replyToId
          ? [
              this.prisma.postComment.update({
                where: { id: commentExist.replyToId },
                data: { repliesCount: { decrement: 1 } },
              }),
            ]
          : []),
      ]);

      // Delete notification for post author (only for root comments)
      // Must match create logic: only root comments create notification for post author
      const isRootComment = !commentExist.replyToId;
      const isNotPostAuthor =
        commentExist.post.authorId !== commentExist.authorId;

      if (isRootComment && isNotPostAuthor) {
        await this.notification.deleteCommentNotification({
          recipientId: commentExist.post.authorId,
          senderId: commentExist.authorId,
          postId: commentExist.postId,
          commentId: commentExist.id,
        });
      }

      // Delete notification for parent comment author (for reply comments)
      if (
        commentExist.replyTo &&
        commentExist.replyTo.authorId !== commentExist.authorId
      ) {
        await this.notification.deleteCommentNotification({
          recipientId: commentExist.replyTo.authorId,
          senderId: commentExist.authorId,
          postId: commentExist.postId,
          commentId: commentExist.id,
        });
      }

      // Delete all mention notifications related to this comment
      await this.notification.deleteCommentMentionNotifications(
        commentExist.id,
      );

      return { deletedComment };
    } catch (error) {
      handleDefaultError(error);
    }
  }

  async deletePostComment({
    commentId,
    authorId,
  }: {
    commentId: string;
    authorId: string;
  }): Promise<IResponseType<PostCommentDataType>> {
    const { deletedComment } = await this.handleDeletePostComment({
      commentId,
      authorId,
    });
    return {
      message: 'Comment deleted successfully',
      data: deletedComment,
      statusCode: 200,
      date: new Date(),
    };
  }

  async deletePostCommentByAdmin({
    commentId,
  }: {
    commentId: string;
  }): Promise<IResponseType<PostCommentDataType>> {
    const { deletedComment } = await this.handleDeletePostComment({
      commentId,
    });
    return {
      message: 'Comment deleted successfully',
      data: deletedComment,
      statusCode: 200,
      date: new Date(),
    };
  }
}
