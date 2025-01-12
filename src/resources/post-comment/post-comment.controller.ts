import {
  Body,
  Controller,
  Get,
  Param,
  Post,
  Query,
  UseGuards,
} from '@nestjs/common';
import { PostCommentService } from './post-comment.service';
import { ApiBearerAuth, ApiTags } from '@nestjs/swagger';
import { AuthGuard } from '@nestjs/passport';
import { RoleGuard } from 'src/guards/role.guard';
import { CreatePostCommentDto } from 'src/resources/post-comment/dto/post-copmment.dto';
import {
  createPostCommentDecorator,
  getPostCommentDecorator,
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
    @Query('page') _page: string,
    @Query('limit') _limit: string,
  ) {
    const { page, limit } = normalizePaginationParams({
      page: parseInt(_page),
      limit: parseInt(_limit),
    });

    return this.postCommentService.getPostComments({ postId, page, limit });
  }
}
