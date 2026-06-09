import {
  Body,
  Controller,
  Delete,
  Get,
  Param,
  Post,
  Query,
  UseGuards,
} from '@nestjs/common';
import { AuthGuard } from '@nestjs/passport';
import { ApiBearerAuth, ApiTags } from '@nestjs/swagger';
import { DecodedAccessToken } from 'src/decorators/decodedAccessToken.decorator';
import { IDecodedAccecssTokenType } from 'src/interfaces/interfaces.global';
import { normalizePaginationParams } from 'src/utils/utils';
import { StoryService } from './story.service';
import {
  CompleteStoryUploadDto,
  CreateStoryDto,
  PresignStoryDto,
} from './dto/story.dto';
import {
  completeStoryUploadDecorator,
  createStoryDecorator,
  deleteStoryDecorator,
  getStoryFeedDecorator,
  getStoryViewersDecorator,
  getUserStoriesDecorator,
  presignStoryUploadDecorator,
  viewStoryDecorator,
} from './story.decorators';

@ApiTags('Story')
@ApiBearerAuth()
@UseGuards(AuthGuard('jwt'))
@Controller('story')
export class StoryController {
  constructor(private readonly storyService: StoryService) {}

  @Post('upload/presign')
  @presignStoryUploadDecorator()
  presignUpload(
    @DecodedAccessToken() decodedAccessToken: IDecodedAccecssTokenType,
    @Body() body: PresignStoryDto,
  ) {
    return this.storyService.presignUpload({
      userId: decodedAccessToken.userId,
      filename: body.filename,
      contentType: body.contentType,
      size: body.size,
    });
  }

  @Post('upload/complete')
  @completeStoryUploadDecorator()
  completeUpload(
    @DecodedAccessToken() decodedAccessToken: IDecodedAccecssTokenType,
    @Body() body: CompleteStoryUploadDto,
  ) {
    return this.storyService.completeUpload({
      userId: decodedAccessToken.userId,
      key: body.key,
      uploadId: body.uploadId,
      parts: body.parts,
    });
  }

  @Post()
  @createStoryDecorator()
  createStory(
    @DecodedAccessToken() decodedAccessToken: IDecodedAccecssTokenType,
    @Body() body: CreateStoryDto,
  ) {
    return this.storyService.createStory({
      userId: decodedAccessToken.userId,
      key: body.key,
      type: body.type,
      duration: body.duration,
    });
  }

  @Get('feed')
  @getStoryFeedDecorator()
  getStoryFeed(
    @DecodedAccessToken() decodedAccessToken: IDecodedAccecssTokenType,
    @Query('limit') _limit?: string,
    @Query('page') _page?: string,
  ) {
    const { limit, page } = normalizePaginationParams({
      limit: +_limit,
      page: +_page,
    });
    return this.storyService.getStoryFeed({
      userId: decodedAccessToken.userId,
      limit,
      page,
    });
  }

  @Get('viewers/:storyId')
  @getStoryViewersDecorator()
  getStoryViewers(
    @DecodedAccessToken() decodedAccessToken: IDecodedAccecssTokenType,
    @Param('storyId') storyId: string,
  ) {
    return this.storyService.getStoryViewers({
      storyId,
      ownerId: decodedAccessToken.userId,
    });
  }

  @Get('user/:userId')
  @getUserStoriesDecorator()
  getUserStories(
    @DecodedAccessToken() decodedAccessToken: IDecodedAccecssTokenType,
    @Param('userId') userId: string,
  ) {
    return this.storyService.getUserStories({
      userId,
      viewerId: decodedAccessToken.userId,
    });
  }

  @Post('view/:storyId')
  @viewStoryDecorator()
  viewStory(
    @DecodedAccessToken() decodedAccessToken: IDecodedAccecssTokenType,
    @Param('storyId') storyId: string,
  ) {
    return this.storyService.viewStory({
      storyId,
      viewerId: decodedAccessToken.userId,
    });
  }

  @Delete(':storyId')
  @deleteStoryDecorator()
  deleteStory(
    @DecodedAccessToken() decodedAccessToken: IDecodedAccecssTokenType,
    @Param('storyId') storyId: string,
  ) {
    return this.storyService.deleteStory({
      storyId,
      userId: decodedAccessToken.userId,
    });
  }
}
