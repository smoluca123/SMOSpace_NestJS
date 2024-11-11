import { Body, Controller, Get, Post, Query, UseGuards } from '@nestjs/common';
import { PostService } from './post.service';
import { ApiQueryLimitAndPage } from 'src/decorators/pagination.decorators';
import { ApiBearerAuth, ApiTags } from '@nestjs/swagger';
import { AuthGuard } from '@nestjs/passport';
import { RoleGuard } from 'src/guards/role.guard';
import { CreatePostDto } from 'src/resources/post/dto/post.dto';
import { createPostDecorator } from 'src/resources/post/post.decorators';
import { DecodedAccessToken } from 'src/decorators/decodedAccessToken.decorator';
import { IDecodedAccecssTokenType } from 'src/interfaces/interfaces.global';

@ApiTags('Post Management')
@ApiBearerAuth()
@UseGuards(AuthGuard('jwt'), RoleGuard)
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
}
