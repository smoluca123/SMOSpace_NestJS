import {
  Body,
  Controller,
  Delete,
  Get,
  Param,
  Post,
  Put,
  Query,
} from '@nestjs/common';
import { PostService } from './post.service';
import { ApiBearerAuth, ApiTags } from '@nestjs/swagger';
import {
  CreatePostDto,
  UpdatePostAsAdminDto,
  UpdatePostDto,
} from 'src/resources/post/dto/post.dto';
import {
  aiGeneratePostDecorator,
  createPostDecorator,
  deletePostAsAdminDecorator,
  deletePostDecorator,
  getLikesPostDecorator,
  getPostDecorator,
  getPostsDecorator,
  getTrendingTopicsDecorator,
  likePostDecorator,
  updatePostAsAdminDecorator,
  updatePostDecorator,
} from 'src/resources/post/post.decorators';
import { DecodedAccessToken } from 'src/decorators/decodedAccessToken.decorator';
import {
  IDecodedAccecssTokenType,
  IResponseType,
} from 'src/interfaces/interfaces.global';
import { PostDataType } from 'src/libs/prisma-types';
import { GeneratePostDto } from 'src/resources/post/dto/ai.dto';
import { normalizePaginationParams } from 'src/utils/utils';

@ApiTags('Post Management')
@ApiBearerAuth()
@Controller('post')
export class PostController {
  constructor(private readonly postService: PostService) {}

  @Get('trending')
  @getTrendingTopicsDecorator()
  getTrendingTopics() {
    return this.postService.getTrendingTopics();
  }

  @Get(':postId')
  @getPostDecorator()
  getPostById(@Param('postId') postId: string) {
    return this.postService.getPostById({ postId });
  }

  @Get('get-likes/:postId')
  @getLikesPostDecorator()
  getLikesPost(
    @Param('postId') postId: string,
    @Query('page') _page: number = 1,
    @Query('limit') _limit: number = 10,
    @Query('userId') userId?: string,
  ) {
    const { limit, page } = normalizePaginationParams({
      limit: _limit,
      page: _page,
    });
    return this.postService.getLikesPost({ postId, limit, page, userId });
  }

  @Get()
  @getPostsDecorator()
  getPosts(
    @Query('limit') _limit: string,
    @Query('page') _page: string,
    @Query('keywords') keywords: string,
    @Query('userId') userId: string,
  ) {
    const { limit, page } = normalizePaginationParams({
      limit: +_limit,
      page: +_page,
    });

    return this.postService.getPosts({
      keywords,
      limit,
      page,
      userId,
    });
  }

  @Post('/ai/generate-post')
  @aiGeneratePostDecorator()
  aiGeneratePost(
    @Body() data: GeneratePostDto,
    @DecodedAccessToken() decodedAccessToken: IDecodedAccecssTokenType,
  ) {
    return this.postService.aiGeneratePost({
      data,
      decodedAccessToken,
    });
  }

  @Post('/like/:postId')
  @likePostDecorator()
  likePost(
    @Param('postId') postId: string,
    @DecodedAccessToken() decodedAccessToken: IDecodedAccecssTokenType,
  ) {
    return this.postService.likePost({
      postId,
      decodedAccessToken,
    });
  }

  @Post()
  @createPostDecorator()
  createPost(
    @DecodedAccessToken() decodedAccessToken: IDecodedAccecssTokenType,
    @Body() data: CreatePostDto,
  ) {
    return this.postService.createPost(decodedAccessToken, data);
  }

  @Put('admin/:postId')
  @updatePostAsAdminDecorator()
  updatePostAsAdmin(
    @Param('postId') postId: string,
    @Body() data: UpdatePostAsAdminDto,
  ): Promise<IResponseType<PostDataType>> {
    return this.postService.updatePostAsAdmin({
      postId,
      data,
    });
  }

  @Put(':postId')
  @updatePostDecorator()
  updatePost(
    @DecodedAccessToken() decodedAccessToken: IDecodedAccecssTokenType,
    @Param('postId') postId: string,
    @Body() data: UpdatePostDto,
  ): Promise<IResponseType<PostDataType>> {
    return this.postService.updatePost({
      postId,
      data,
      decodedAccessToken,
    });
  }

  @Delete('admin/:postId')
  @deletePostAsAdminDecorator()
  deletePostAsAdmin(
    @Param('postId') postId: string,
  ): Promise<IResponseType<PostDataType>> {
    return this.postService.deletePostAsAdmin({ postId });
  }

  @Delete(':postId')
  @deletePostDecorator()
  deletePost(
    @Param('postId') postId: string,
    @DecodedAccessToken() decodedAccessToken: IDecodedAccecssTokenType,
  ) {
    return this.postService.deletePost({ postId, decodedAccessToken });
  }
}
