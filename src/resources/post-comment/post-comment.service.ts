import { Injectable, NotFoundException } from '@nestjs/common';
import { handleDefaultError } from 'src/global/functions.global';
import { IResponseType } from 'src/interfaces/interfaces.global';
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

      const [, createdComment] = await this.prisma.$transaction([
        this.prisma.post.update({
          where: { id: postId },
          data: { commentCount: { increment: 1 } },
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
}
