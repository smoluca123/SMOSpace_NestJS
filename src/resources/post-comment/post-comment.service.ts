import { Injectable, NotFoundException } from '@nestjs/common';
import { Prisma } from '@prisma/client';
import { handleDefaultError } from 'src/global/functions.global';
import {
  IPaginationResponseType,
  IResponseType,
} from 'src/interfaces/interfaces.global';
import {
  postCommentDataSelect,
  PostCommentDataType,
} from 'src/libs/prisma-types';
import { PrismaService } from 'src/prisma/prisma.service';
import { CreatePostCommentDto } from 'src/resources/post-comment/dto/post-copmment.dto';

@Injectable()
export class PostCommentService {
  constructor(private readonly prisma: PrismaService) {}

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

      const { content, replyToId } = data;
      let parentComment: { id: string; level: number } | null = null;
      if (replyToId) {
        parentComment = await this.prisma.postComment.findUnique({
          where: {
            id: data.replyToId,
          },
          select: {
            id: true,
            level: true,
          },
        });
        if (!parentComment) {
          throw new NotFoundException('Parent comment not found');
        }
      }

      const [, , createdComment] = await this.prisma.$transaction([
        this.prisma.post.update({
          where: { id: postId },
          data: { commentCount: { increment: 1 } },
          select: null,
        }),
        this.prisma.postComment.update({
          where: { id: replyToId },
          data: { repliesCount: { increment: 1 } },
          select: null,
        }),
        this.prisma.postComment.create({
          data: {
            content,
            replyToId: replyToId || null,
            postId,
            authorId,
            level: replyToId ? parentComment.level + 1 : 0,
          },
          select: postCommentDataSelect,
        }),
      ]);
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
  }: {
    postId: string;
    page: number;
    limit: number;
    replyTo: string;
  }): Promise<IPaginationResponseType<PostCommentDataType>> {
    try {
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
        ...(replyTo && { replyToId: replyTo }),
      };

      const [comments, totalCount] = await this.prisma.$transaction([
        this.prisma.postComment.findMany({
          where: whereQuery,
          skip: (page - 1) * limit,
          take: limit,
          select: postCommentDataSelect,
        }),
        this.prisma.postComment.count({
          where: whereQuery,
        }),
      ]);

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
          items: comments,
        },
        statusCode: 200,
        date: new Date(),
      };
    } catch (error) {
      handleDefaultError(error);
    }
  }
}
