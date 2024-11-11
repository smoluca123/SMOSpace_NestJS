import { Injectable } from '@nestjs/common';
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
} from 'src/libs/prisma-types';
import { PrismaService } from 'src/prisma/prisma.service';
import { CreatePostDto } from 'src/resources/post/dto/post.dto';

@Injectable()
export class PostService {
  constructor(private readonly prisma: PrismaService) {}
  async getPosts({
    limit,
    page,
  }: {
    limit: number;
    page: number;
  }): Promise<IPaginationResponseType<PostDataType>> {
    try {
      const posts = await this.prisma.post.findMany({
        where: {
          isPrivate: false,
        },
        take: limit,
        skip: (page - 1) * limit,
        include: postDataInclude,
      });

      const totalCount = await this.prisma.post.count();
      const totalPage = Math.ceil(totalCount / limit);
      const hasNextPage = page * limit < totalCount;
      const hasPreviousPage = page > 1;

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
}
