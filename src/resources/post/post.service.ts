import {
  BadRequestException,
  ForbiddenException,
  Injectable,
  NotFoundException,
} from '@nestjs/common';
import { Prisma } from '@prisma/client';
import openai from 'src/configs/openai.config';
import {
  blockResultMessage,
  POST_AI_PROMPTS,
} from 'src/global/constant.global';
import { handleDefaultError } from 'src/global/functions.global';
import {
  IBaseResponseAIType,
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
  TrendingTopicType,
  userDataSelect,
  // TrendingTopicType,
} from 'src/libs/prisma-types';
import { PrismaService } from 'src/prisma/prisma.service';
import { PostGateway } from 'src/resources/gateways/post/post.gateway';
import {
  CreatePostDto,
  UpdatePostAsAdminDto,
  UpdatePostDto,
} from 'src/resources/post/dto/post.dto';
import { S3Service } from 'src/services/aws/s3/s3.service';

@Injectable()
export class PostService {
  constructor(
    private readonly prisma: PrismaService,
    private readonly postGateway: PostGateway,
    private readonly s3Service: S3Service,
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

  async getPosts({
    keywords = '',
    limit,
    page,
    userId,
    likeUserId,
    getPrivatePost = false,
    followUserId,
  }: {
    keywords?: string;
    limit: number;
    page: number;
    userId?: string;
    likeUserId?: string;
    getPrivatePost?: boolean;
    followUserId?: string;
  }): Promise<IPaginationResponseType<PostDataType>> {
    try {
      const whereQuery: Prisma.PostWhereInput = {
        authorId: userId || undefined,
        ...(!getPrivatePost ? { isPrivate: false } : {}),
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

      const postsWithLikeStatus = posts.map(({ likes, ...post }) => ({
        ...post,
        isLiked: likes.length > 0,
      }));

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
      const post = await this.validatePost<PostDataTypeWithLikes>(postId, {
        ...postDataSelect,
        likes: {
          where: {
            userId: likeUserId || '',
          },
          select: {
            userId: true,
          },
        },
      });
      // if (!postId) {
      //   throw new BadRequestException({
      //     message: 'Post id is required',
      //     statusCode: 400,
      //     date: new Date(),
      //   });
      // }

      // const post = await this.prisma.post.findUnique({
      //   where: { id: postId },
      //   select: {
      //     ...postDataSelect,
      //     likes: {
      //       where: {
      //         userId: likeUserId || '',
      //       },
      //       select: {
      //         userId: true,
      //       },
      //     },
      //   },
      // });

      if (!post) {
        throw new NotFoundException({
          message: 'Post not found',
          statusCode: 404,
          date: new Date(),
        });
      }

      // eslint-disable-next-line @typescript-eslint/no-unused-vars
      const { likes, ...postWithLikeStatus } = {
        ...post,
        isLiked: post.likes.length > 0,
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
  }: {
    postId: string;
    page: number;
    limit: number;
    userId?: string;
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
      };

      const [likes, totalCount] = await this.prisma.$transaction([
        this.prisma.postLike.findMany({
          where: whereQuery,
          take: limit,
          skip: (page - 1) * limit,
          orderBy: { createdAt: 'desc' },

          select: {
            id: true,
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
      const { images: imagesData, ...postData } = data;
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

  async likePost({
    postId,
    decodedAccessToken,
  }: {
    postId: string;
    decodedAccessToken: IDecodedAccecssTokenType;
  }): Promise<IResponseType<PostDataType & { isLiked: boolean }>> {
    try {
      if (!postId) {
        throw new BadRequestException({
          message: 'Post id is required',
          statusCode: 400,
          date: new Date(),
        });
      }

      // Tối ưu: Chỉ lấy các trường cần thiết và kiểm tra like trong 1 query
      const post = await this.prisma.post.findUnique({
        where: { id: postId },
        select: {
          ...postDataSelect,
          likes: {
            where: {
              userId: decodedAccessToken.userId,
            },
            select: {
              userId: true,
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

      const isLiked =
        post.likes && post.likes[0]?.userId === decodedAccessToken.userId;

      // Tối ưu: Sử dụng 1 transaction duy nhất cho cả like và unlike
      // eslint-disable-next-line @typescript-eslint/no-unused-vars
      const [_, updatedPost] = await this.prisma.$transaction([
        isLiked
          ? this.prisma.postLike.deleteMany({
              where: {
                postId: postId,
                userId: decodedAccessToken.userId,
              },
            })
          : this.prisma.postLike.create({
              data: {
                postId,
                userId: decodedAccessToken.userId,
              },
            }),
        this.prisma.post.update({
          where: { id: postId },
          data: {
            likeCount: {
              [isLiked ? 'decrement' : 'increment']: 1,
            },
          },
          select: postDataSelect,
        }),
      ]);

      return {
        message: 'Post liked/unliked successfully',
        data: { ...updatedPost, isLiked: !isLiked },
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
      select: { authorId: true },
    });

    if (!post) {
      throw new NotFoundException('Post not found');
    }

    // Delete post images
    this.s3Service.deletePostImages({ postId });

    if (userId) {
      // If userId provided, verify user exists and has permission
      const user = await this.prisma.user.findUnique({
        where: { id: userId },
      });

      if (!user) {
        throw new NotFoundException('User not found');
      }

      if (post.authorId !== userId) {
        throw new ForbiddenException('This comment is not yours');
      }

      // Delete post and decrement user's post count in a transaction
      const [, deletedPost] = await this.prisma.$transaction([
        this.prisma.user.update({
          where: { id: userId },
          data: { postCount: { decrement: 1 } },
        }),
        this.prisma.post.delete({
          where: { id: postId },
          select: postDataSelect,
        }),
      ]);

      return {
        message: 'Post deleted successfully',
        data: deletedPost,
        statusCode: 200,
        date: new Date(),
      };
    }

    // Delete post and decrement user's post count in a transaction
    const [, deletedPost] = await this.prisma.$transaction([
      this.prisma.user.update({
        where: { id: post.authorId },
        data: { postCount: { decrement: 1 } },
      }),
      this.prisma.post.delete({
        where: { id: postId },
        select: postDataSelect,
      }),
    ]);

    return {
      message: 'Post deleted successfully',
      data: deletedPost,
      statusCode: 200,
      date: new Date(),
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
}
