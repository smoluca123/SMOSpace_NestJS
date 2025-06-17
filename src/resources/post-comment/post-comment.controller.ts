import {
  Body,
  Controller,
  Delete,
  Get,
  Param,
  Patch,
  Post,
  Query,
  UseGuards,
} from '@nestjs/common';
import { PostCommentService } from './post-comment.service';
import { ApiBearerAuth, ApiTags } from '@nestjs/swagger';
import { AuthGuard } from '@nestjs/passport';
import { RoleGuard } from 'src/guards/role.guard';
import {
  CreatePostCommentDto,
  UpdatePostCommentDto,
} from 'src/resources/post-comment/dto/post-copmment.dto';
import {
  createPostCommentDecorator,
  deletePostCommentByAdminDecorator,
  deletePostCommentDecorator,
  getCommentCountDecorator,
  getPostCommentDecorator,
  updatePostCommentByAdminDecorator,
  updatePostCommentDecorator,
} from 'src/resources/post-comment/post-comment.decorators';
import { DecodedAccessToken } from 'src/decorators/decodedAccessToken.decorator';
import { IDecodedAccecssTokenType } from 'src/interfaces/interfaces.global';
import { normalizePaginationParams } from 'src/utils/utils';

@ApiTags('Post Comment')
@ApiBearerAuth()
@UseGuards(AuthGuard('jwt'), RoleGuard)
@Controller('/post/comment')
export class PostCommentController {
  constructor(private readonly postCommentService: PostCommentService) {}

  @Get('/count')
  @getCommentCountDecorator()
  getCommentCount() {
    return this.postCommentService.getCommentCount();
  }

  @Post('/:postId')
  @createPostCommentDecorator()
  createPostComment(
    @DecodedAccessToken() decodedAccessToken: IDecodedAccecssTokenType,
    @Param('postId') postId: string,
    @Body() data: CreatePostCommentDto,
  ) {
    const { userId } = decodedAccessToken;
    return this.postCommentService.createPostComment({
      postId,
      data,
      authorId: userId,
    });
  }

  @Get('/:postId')
  @getPostCommentDecorator()
  getPostComments(
    @Param('postId') postId: string,
    @Query('replyTo') replyTo: string,
    @Query('page') _page: string,
    @Query('limit') _limit: string,
  ) {
    const { page, limit } = normalizePaginationParams({
      page: parseInt(_page),
      limit: parseInt(_limit),
    });

    return this.postCommentService.getPostComments({
      postId,
      page,
      limit,
      replyTo,
    });
  }

  @Patch('/:commentId')
  @updatePostCommentDecorator()
  updatePostComment(
    @Param('commentId') commentId: string,
    @Body() data: UpdatePostCommentDto,
    @DecodedAccessToken() decodedAccessToken: IDecodedAccecssTokenType,
  ) {
    const { userId } = decodedAccessToken;
    return this.postCommentService.updatePostComment({
      commentId,
      data,
      authorId: userId,
    });
  }

  @Patch('/admin/:commentId')
  @updatePostCommentByAdminDecorator()
  updatePostCommentByAdmin(
    @Param('commentId') commentId: string,
    @Body() data: UpdatePostCommentDto,
  ) {
    return this.postCommentService.updatePostCommentByAdmin({
      commentId,
      data,
    });
  }

  @Delete('/:commentId')
  @deletePostCommentDecorator()
  deletePostComment(
    @Param('commentId') commentId: string,
    @DecodedAccessToken() decodedAccessToken: IDecodedAccecssTokenType,
  ) {
    const { userId } = decodedAccessToken;
    return this.postCommentService.deletePostComment({
      commentId,
      authorId: userId,
    });
  }

  @Delete('/admin/:commentId')
  @deletePostCommentByAdminDecorator()
  deletePostCommentByAdmin(@Param('commentId') commentId: string) {
    return this.postCommentService.deletePostCommentByAdmin({ commentId });
  }
}
