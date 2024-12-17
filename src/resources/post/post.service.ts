import {
  BadRequestException,
  ForbiddenException,
  Injectable,
  NotFoundException,
} from '@nestjs/common';
import { Prisma } from '@prisma/client';
import { handleDefaultError } from 'src/global/functions.global';
import {
  IDecodedAccecssTokenType,
  IPaginationResponseType,
  IResponseType,
} from 'src/interfaces/interfaces.global';
import {
  postDataInclude,
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
  }: {
    keywords: string;
    limit: number;
    page: number;
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
          include: postDataInclude,
          orderBy: { createdAt: 'desc' },
        }),
      ]);

      const totalPage = Math.ceil(totalCount / limit);
      const hasNextPage = page * limit < totalCount;
      const hasPreviousPage = !!totalCount && page > 1;

      return {
        message: 'Posts fetched successfully',
        data: {
          items: posts,
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
  }: {
    postId: string;
    page: number;
    limit: number;
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

      const [likes, totalCount] = await this.prisma.$transaction([
        this.prisma.postLike.findMany({
          where: {
            postId,
          },
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
          where: {
            postId,
          },
        }),
      ]);

      const currentPage = page;
      const totalPage = Math.ceil(totalCount / limit);
      const hasNextPage = page * limit < totalCount;
      const hasPreviousPage = !!totalCount && page > 1;

      return {
        message: 'Likes fetched successfully',
        data: {
          items: likes,
          post,
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
      const post = await this.prisma.post.create({
        data: {
          ...data,
          authorId: userId,
        },
        select: postDataSelect,
      });
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
  }): Promise<
    IResponseType<{
      isLiked: boolean;
      post: PostDataType;
    }>
  > {
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
            }
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

      const isLiked = post.likes && post.likes.length > 0;

      // Tối ưu: Sử dụng 1 transaction duy nhất cho cả like và unlike
      // eslint-disable-next-line @typescript-eslint/no-unused-vars
      const [_, updatedPost] = await this.prisma.$transaction([
        isLiked
          ? this.prisma.postLike.delete({
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
        data: {
          isLiked: !isLiked,
          post: updatedPost,
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
