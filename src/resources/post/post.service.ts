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
  PostLikeDataType,
  TrendingTopicType,
  userDataSelect,
  // TrendingTopicType,
} from 'src/libs/prisma-types';
import { PrismaService } from 'src/prisma/prisma.service';
import {
  CreatePostDto,
  UpdatePostAsAdminDto,
  UpdatePostDto,
} from 'src/resources/post/dto/post.dto';

@Injectable()
export class PostService {
  constructor(private readonly prisma: PrismaService) {}
  async getPosts({
    keywords = '',
    limit,
    page,
    userId,
  }: {
    keywords?: string;
    limit: number;
    page: number;
    userId?: string;
  }): Promise<IPaginationResponseType<PostDataType>> {
    try {
      const whereQuery: Prisma.PostWhereInput = {
        isPrivate: false,
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
                userId: userId || '',
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
          items: postsWithLikeStatus,
          totalCount,
          totalPage,
          currentPage: page,
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

  async getPostById({
    postId,
  }: {
    postId: string;
  }): Promise<IResponseType<PostDataType>> {
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
        select: postDataSelect,
      });

      if (!post) {
        throw new NotFoundException({
          message: 'Post not found',
          statusCode: 404,
          date: new Date(),
        });
      }
      return {
        message: 'Post fetched successfully',
        data: post,
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
        userId: userId || undefined,
        // OR: [{ userId: userId || undefined }],
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
            ...data,
            authorId: userId,
          },
          select: postDataSelect,
        }),
      ]);
      return {
        message: 'Post created successfully',
        data: post,
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
      const user = await this.prisma.user.findUnique({
        where: {
          id: decodedAccessToken.userId,
        },
        select: {
          credits: true,
        },
      });

      if (user.credits.lte(0)) {
        throw new BadRequestException({
          message: 'Not enough credits',
          date: new Date(),
        });
      }

      const updateUser = await this.prisma.user.update({
        where: {
          id: decodedAccessToken.userId,
        },
        data: {
          credits: {
            decrement: 1,
          },
        },
        select: {
          credits: true,
        },
      });

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
          price: '1 credits',
          priceNum: 1,
          currentCredits: updateUser.credits,
          statusCode: 400,
          date: new Date(),
        });

      return {
        message: 'AI generated a post successfully',
        data: {
          price: '1 credits',
          priceNum: 1,
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

  async deletePost({ postId, decodedAccessToken }) {
    try {
      const { userId } = decodedAccessToken;
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

      await this.prisma.$transaction([
        this.prisma.user.update({
          where: {
            id: userId,
          },
          data: {
            credits: {
              decrement: 1,
            },
          },
        }),
        this.prisma.post.delete({
          where: {
            id: postId,
          },
        }),
      ]);

      return {
        message: 'Post deleted successfully',
        data: null,
        statusCode: 200,
        date: new Date(),
      };
    } catch (error) {
      handleDefaultError(error);
    }
  }

  async deletePostAsAdmin({
    postId,
  }: {
    postId: string;
  }): Promise<IResponseType<null>> {
    try {
      await this.prisma.post.delete({
        where: {
          id: postId,
        },
      });
      return {
        message: 'Post deleted successfully',
        data: null,
        statusCode: 200,
        date: new Date(),
      };
    } catch (error) {
      handleDefaultError(error);
    }
  }
}
