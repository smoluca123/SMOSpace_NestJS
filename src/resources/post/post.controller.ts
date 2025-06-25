import {
  Body,
  Controller,
  Delete,
  Get,
  Param,
  Patch,
  Post,
  Query,
  UploadedFiles,
  UseGuards,
} from '@nestjs/common';
import { PostService } from './post.service';
import { ApiBearerAuth, ApiTags } from '@nestjs/swagger';
import {
  CreatePostDto,
  DeletePostsDto,
  UpdatePostAsAdminDto,
  UpdatePostDto,
} from 'src/resources/post/dto/post.dto';
import {
  aiGeneratePostDecorator,
  createPostDecorator,
  deletePostAsAdminDecorator,
  deletePostDecorator,
  deletePostsDecorator,
  getLikesPostDecorator,
  getMyPostsDecorator,
  getPostCountDecorator,
  getPostDecorator,
  getPostsAdminDecorator,
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
import { AuthGuard } from '@nestjs/passport';
import { RoleGuard } from 'src/guards/role.guard';

@ApiTags('Post Management')
@ApiBearerAuth()
@UseGuards(AuthGuard('jwt'), RoleGuard)
@Controller('post')
export class PostController {
  constructor(private readonly postService: PostService) {}

  @Get('/count')
  @getPostCountDecorator()
  getPostCount() {
    return this.postService.getPostCount();
  }

  @Get('/my-posts')
  @getMyPostsDecorator()
  getMyPosts(
    @DecodedAccessToken() decodedAccessToken: IDecodedAccecssTokenType,
    @Query('limit') _limit?: string,
    @Query('page') _page?: string,
    @Query('keywords') keywords?: string,
  ) {
    const { limit, page } = normalizePaginationParams({
      limit: +_limit,
      page: +_page,
    });

    const { userId } = decodedAccessToken;

    return this.postService.getPosts({
      keywords,
      limit,
      page,
      userId,
      likeUserId: userId,
      getPrivatePost: true,
    });
  }

  @Get('/following-posts')
  @getMyPostsDecorator()
  getFollowingPosts(
    @DecodedAccessToken() decodedAccessToken: IDecodedAccecssTokenType,
    @Query('limit') _limit?: string,
    @Query('page') _page?: string,
    @Query('keywords') keywords?: string,
  ) {
    const { limit, page } = normalizePaginationParams({
      limit: +_limit,
      page: +_page,
    });

    const { userId } = decodedAccessToken;

    return this.postService.getPosts({
      keywords,
      limit,
      page,
      likeUserId: userId,
      followUserId: userId,
    });
  }

  @Get('trending')
  @getTrendingTopicsDecorator()
  getTrendingTopics() {
    return this.postService.getTrendingTopics();
  }

  @Get('/admin/get-post')
  @getPostsAdminDecorator()
  getPostsAdmin(
    @Query('limit') _limit?: string,
    @Query('page') _page?: string,
    @Query('keywords') keywords?: string,
  ) {
    const { limit, page } = normalizePaginationParams({
      limit: +_limit,
      page: +_page,
    });

    return this.postService.getPosts({
      limit,
      page,
      keywords,
      getPrivatePost: true,
    });
  }

  @Get('/admin/get-post/:userId')
  @getPostsAdminDecorator()
  getPostsByUserIdAdmin(
    @Query('limit') _limit?: string,
    @Query('page') _page?: string,
    @Query('keywords') keywords?: string,
    @Param('userId') userId?: string,
  ) {
    const { limit, page } = normalizePaginationParams({
      limit: +_limit,
      page: +_page,
    });

    return this.postService.getPosts({
      limit,
      page,
      keywords,
      getPrivatePost: true,
      userId,
    });
  }

  @Get('get-likes/:postId')
  @getLikesPostDecorator()
  getLikesPost(
    @Param('postId') postId: string,
    @Query('page') _page: string,
    @Query('limit') _limit: string,
    @Query('userId') userId?: string,
  ) {
    const { limit, page } = normalizePaginationParams({
      limit: +_limit,
      page: +_page,
    });
    return this.postService.getLikesPost({ postId, limit, page, userId });
  }

  @Get(':postId')
  @getPostDecorator()
  getPostById(
    @Param('postId') postId: string,
    @Query('likeUserId') likeUserId?: string,
  ) {
    return this.postService.getPostById({ postId, likeUserId });
  }

  @Get('/')
  @getPostsDecorator()
  getPosts(
    @Query('limit') _limit?: string,
    @Query('page') _page?: string,
    @Query('keywords') keywords?: string,
    @Query('userId') userId?: string,
    @Query('likeUserId') likeUserId?: string,
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
      likeUserId,
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
    @UploadedFiles() images: Express.Multer.File[],
  ) {
    return this.postService.createPost(decodedAccessToken, {
      ...data,
      images,
    });
  }

  @Patch('admin/:postId')
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

  @Patch(':postId')
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

  @Delete('admin/delete-posts')
  @deletePostsDecorator()
  deletePosts(@Body() data: DeletePostsDto) {
    const { postIds } = data;
    return this.postService.handleDeletePosts(postIds);
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
