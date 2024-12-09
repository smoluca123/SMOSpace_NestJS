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
import { ApiQueryLimitAndPage } from 'src/decorators/pagination.decorators';
import { ApiBearerAuth, ApiTags } from '@nestjs/swagger';
import {
  CreatePostDto,
  UpdatePostAsAdminDto,
  UpdatePostDto,
} from 'src/resources/post/dto/post.dto';
import {
  createPostDecorator,
  deletePostAsAdminDecorator,
  deletePostDecorator,
  updatePostAsAdminDecorator,
  updatePostDecorator,
} from 'src/resources/post/post.decorators';
import { DecodedAccessToken } from 'src/decorators/decodedAccessToken.decorator';
import {
  IDecodedAccecssTokenType,
  IResponseType,
} from 'src/interfaces/interfaces.global';
import { PostDataType } from 'src/libs/prisma-types';

@ApiTags('Post Management')
@ApiBearerAuth()
@Controller('post')
export class PostController {
  constructor(private readonly postService: PostService) {}

  @Get()
  @ApiQueryLimitAndPage()
  getPosts(@Query('limit') limit: number, @Query('page') page: number) {
    const initLimit = +limit || 10;
    const initPage = +page || 1;
    return this.postService.getPosts({
      limit: initLimit,
      page: initPage,
    });
  }

  @Post()
  @createPostDecorator()
  createPost(
    @DecodedAccessToken() decodedAccessToken: IDecodedAccecssTokenType,
    @Body() data: CreatePostDto,
  ) {
    // Implement post creation logic
    return this.postService.createPost(decodedAccessToken, data);
  }

  @Put('/:postId')
  @updatePostDecorator()
  updatePost(
    @DecodedAccessToken() decodedAccessToken: IDecodedAccecssTokenType,
    @Param('postId') postId: string,
    @Body() data: UpdatePostDto,
  ): Promise<IResponseType<PostDataType>> {
    // Implement post update logic
    return this.postService.updatePost({
      postId,
      data,
      decodedAccessToken,
    });
  }

  @Put('/update/:postId')
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

  @Delete('/:postId')
  @deletePostDecorator()
  deletePost(
    @Param('postId') postId: string,
    @DecodedAccessToken() decodedAccessToken: IDecodedAccecssTokenType,
  ) {
    return this.postService.deletePost({ postId, decodedAccessToken });
  }

  @Delete('/delete/:postId')
  @deletePostAsAdminDecorator()
  deletePostAsAdmin(
    @Param('postId') postId: string,
  ): Promise<IResponseType<PostDataType>> {
    return this.postService.deletePostAsAdmin({ postId });
  }
}
