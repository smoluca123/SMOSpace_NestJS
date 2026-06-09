import {
  BadRequestException,
  ForbiddenException,
  Injectable,
  NotFoundException,
} from '@nestjs/common';
import { FriendStatus, MediaType } from '@prisma/client';
import { handleDefaultError } from 'src/global/functions.global';
import {
  IBeforeTransformPaginationResponseType,
  IBeforeTransformResponseType,
  IResponseType,
} from 'src/interfaces/interfaces.global';
import {
  storyDataSelect,
  StoryDataType,
  userDataSelect,
  UserDataType,
} from 'src/libs/prisma-types';
import { PrismaService } from 'src/prisma/prisma.service';
import { S3Service } from 'src/services/aws/s3/s3.service';
import { ConfigService } from '@nestjs/config';

/** Stories live for 24 hours. */
const STORY_TTL_MS = 24 * 60 * 60 * 1000;

/** Files larger than this are uploaded with multipart; part size in bytes. */
const MULTIPART_PART_SIZE = 16 * 1024 * 1024; // 16MB
/** Hard cap for a story upload. */
const MAX_STORY_BYTES = 200 * 1024 * 1024; // 200MB

export type StoryWithViewedType = StoryDataType & { isViewed: boolean };

export type StoryGroupType = {
  author: UserDataType;
  stories: StoryWithViewedType[];
  hasUnviewed: boolean;
  latestAt: string | Date;
};

@Injectable()
export class StoryService {
  constructor(
    private readonly prisma: PrismaService,
    private readonly s3Service: S3Service,
    private readonly configService: ConfigService,
  ) {}

  /** Object key for a story media file, scoped to the owner. */
  private buildStoryKey(userId: string, filename: string): string {
    const publicDir = this.configService.get('S3_PUBLIC_DIR');
    const safe = (filename || `story-${Date.now()}`).replace(/[^\w.\-]+/g, '_');
    return `${publicDir}/stories/${userId}/${new Date().getFullYear()}/${Date.now()}_${safe}`;
  }

  /** Prefix every story key for a user must start with (ownership guard). */
  private storyKeyPrefix(userId: string): string {
    const publicDir = this.configService.get('S3_PUBLIC_DIR');
    return `${publicDir}/stories/${userId}/`;
  }

  /**
   * Issue a presigned upload (direct-to-Storj). Small files get a single PUT
   * URL; larger files get a multipart upload with one presigned URL per part.
   */
  async presignUpload({
    userId,
    filename,
    contentType,
    size,
  }: {
    userId: string;
    filename: string;
    contentType: string;
    size: number;
  }): Promise<
    IBeforeTransformResponseType<
      | { mode: 'single'; key: string; url: string }
      | {
          mode: 'multipart';
          key: string;
          uploadId: string;
          partSize: number;
          urls: { partNumber: number; url: string }[];
        }
    >
  > {
    try {
      const isImage = contentType.startsWith('image/');
      const isVideo = contentType.startsWith('video/');
      if (!isImage && !isVideo) {
        throw new BadRequestException(
          'Only image or video stories are allowed',
        );
      }
      if (size > MAX_STORY_BYTES) {
        throw new BadRequestException('File is too large');
      }

      const key = this.buildStoryKey(userId, filename);

      // Single PUT for small files.
      if (size <= MULTIPART_PART_SIZE) {
        const url = await this.s3Service.presignPutObject({ key, contentType });
        return {
          type: 'response',
          message: 'Presigned upload',
          data: { mode: 'single', key, url },
        };
      }

      // Multipart for large files.
      const uploadId = await this.s3Service.createMultipartUpload({
        key,
        contentType,
      });
      const partCount = Math.ceil(size / MULTIPART_PART_SIZE);
      const urls = await Promise.all(
        Array.from({ length: partCount }, (_, i) => i + 1).map(
          async (partNumber) => ({
            partNumber,
            url: await this.s3Service.presignUploadPart({
              key,
              uploadId,
              partNumber,
            }),
          }),
        ),
      );

      return {
        type: 'response',
        message: 'Presigned multipart upload',
        data: {
          mode: 'multipart',
          key,
          uploadId,
          partSize: MULTIPART_PART_SIZE,
          urls,
        },
      };
    } catch (error) {
      handleDefaultError(error);
    }
  }

  /** Finalize a multipart upload. */
  async completeUpload({
    userId,
    key,
    uploadId,
    parts,
  }: {
    userId: string;
    key: string;
    uploadId: string;
    parts: { partNumber: number; etag: string }[];
  }): Promise<IBeforeTransformResponseType<{ success: boolean }>> {
    try {
      if (!key.startsWith(this.storyKeyPrefix(userId))) {
        throw new ForbiddenException('Invalid upload key');
      }
      await this.s3Service.completeMultipartUpload({ key, uploadId, parts });
      return {
        type: 'response',
        message: 'Upload completed',
        data: { success: true },
      };
    } catch (error) {
      handleDefaultError(error);
    }
  }

  /**
   * Create the story record after the media has been uploaded to Storj.
   * Validates the key belongs to the user and that the object actually exists.
   */
  async createStory({
    userId,
    key,
    type,
    duration,
  }: {
    userId: string;
    key: string;
    type: MediaType;
    duration?: number;
  }): Promise<IResponseType<StoryDataType>> {
    try {
      if (!key.startsWith(this.storyKeyPrefix(userId))) {
        throw new ForbiddenException('Invalid upload key');
      }

      const exists = await this.s3Service.objectExists(key);
      if (!exists) {
        throw new BadRequestException('Uploaded media not found');
      }

      const story = await this.prisma.story.create({
        data: {
          authorId: userId,
          mediaUrl: this.s3Service.buildPublicUrl(key),
          type,
          duration:
            type === MediaType.VIDEO ? Math.round(duration ?? 0) || null : null,
          expiresAt: new Date(Date.now() + STORY_TTL_MS),
        },
        select: storyDataSelect,
      });

      return {
        message: 'Story created successfully',
        data: story,
        statusCode: 201,
        date: new Date(),
      };
    } catch (error) {
      handleDefaultError(error);
    }
  }

  /**
   * The set of author ids whose stories the viewer is allowed to see: the
   * viewer themselves, people they follow, and accepted friends.
   */
  private async getVisibleAuthorIds(userId: string): Promise<string[]> {
    const [followings, friends] = await Promise.all([
      this.prisma.follow.findMany({
        where: { followerId: userId },
        select: { followingId: true },
      }),
      this.prisma.friend.findMany({
        where: {
          status: FriendStatus.ACCEPTED,
          OR: [{ userId }, { friendId: userId }],
        },
        select: { userId: true, friendId: true },
      }),
    ]);

    const ids = new Set<string>([userId]);
    followings.forEach((f) => ids.add(f.followingId));
    friends.forEach((f) =>
      ids.add(f.userId === userId ? f.friendId : f.userId),
    );
    return [...ids];
  }

  async getStoryFeed({
    userId,
    limit = 15,
    page = 1,
  }: {
    userId: string;
    limit?: number;
    page?: number;
  }): Promise<IBeforeTransformPaginationResponseType<StoryGroupType>> {
    try {
      const authorIds = await this.getVisibleAuthorIds(userId);

      // Authors who currently have active stories, with their latest story time.
      // Paginating at the author-group level keeps groups intact across pages.
      const grouped = await this.prisma.story.groupBy({
        by: ['authorId'],
        where: {
          authorId: { in: authorIds },
          expiresAt: { gt: new Date() },
        },
        _max: { createdAt: true },
      });

      // Stable order: my own group first, then by most recent story.
      const sortedAuthorIds = grouped
        .sort((a, b) => {
          if (a.authorId === userId) return -1;
          if (b.authorId === userId) return 1;
          return (
            new Date(b._max.createdAt ?? 0).getTime() -
            new Date(a._max.createdAt ?? 0).getTime()
          );
        })
        .map((g) => g.authorId);

      const totalCount = sortedAuthorIds.length;
      const pageAuthorIds = sortedAuthorIds.slice(
        (page - 1) * limit,
        page * limit,
      );

      const stories = await this.prisma.story.findMany({
        where: {
          authorId: { in: pageAuthorIds },
          expiresAt: { gt: new Date() },
        },
        orderBy: { createdAt: 'asc' },
        select: storyDataSelect,
      });

      const viewedRows = await this.prisma.storyView.findMany({
        where: {
          viewerId: userId,
          storyId: { in: stories.map((s) => s.id) },
        },
        select: { storyId: true },
      });
      const viewedSet = new Set(viewedRows.map((v) => v.storyId));

      // Group stories by author.
      const groupMap = new Map<string, StoryGroupType>();
      for (const story of stories) {
        const isViewed = viewedSet.has(story.id);
        const existing = groupMap.get(story.author.id);
        if (existing) {
          existing.stories.push({ ...story, isViewed });
          existing.hasUnviewed = existing.hasUnviewed || !isViewed;
          existing.latestAt = story.createdAt;
        } else {
          groupMap.set(story.author.id, {
            author: story.author,
            stories: [{ ...story, isViewed }],
            hasUnviewed: !isViewed,
            latestAt: story.createdAt,
          });
        }
      }

      // Preserve the paginated author order.
      const items = pageAuthorIds
        .map((id) => groupMap.get(id))
        .filter((g): g is StoryGroupType => !!g);

      return {
        type: 'pagination',
        message: 'Story feed',
        data: {
          items,
          totalCount,
          currentPage: page,
          pageSize: limit,
        },
      };
    } catch (error) {
      handleDefaultError(error);
    }
  }

  async getUserStories({
    userId,
    viewerId,
  }: {
    userId: string;
    viewerId: string;
  }): Promise<IBeforeTransformResponseType<StoryWithViewedType[]>> {
    try {
      const stories = await this.prisma.story.findMany({
        where: { authorId: userId, expiresAt: { gt: new Date() } },
        orderBy: { createdAt: 'asc' },
        select: storyDataSelect,
      });

      const viewedRows = await this.prisma.storyView.findMany({
        where: { viewerId, storyId: { in: stories.map((s) => s.id) } },
        select: { storyId: true },
      });
      const viewedSet = new Set(viewedRows.map((v) => v.storyId));

      return {
        type: 'response',
        message: 'User stories',
        data: stories.map((s) => ({ ...s, isViewed: viewedSet.has(s.id) })),
      };
    } catch (error) {
      handleDefaultError(error);
    }
  }

  async viewStory({
    storyId,
    viewerId,
  }: {
    storyId: string;
    viewerId: string;
  }): Promise<IBeforeTransformResponseType<{ success: boolean }>> {
    try {
      const story = await this.prisma.story.findUnique({
        where: { id: storyId },
        select: { id: true, authorId: true },
      });
      if (!story) throw new NotFoundException('Story not found');

      // Authors don't count as viewers of their own story.
      if (story.authorId === viewerId) {
        return {
          type: 'response',
          message: 'Own story',
          data: { success: true },
        };
      }

      const existing = await this.prisma.storyView.findUnique({
        where: { storyId_viewerId: { storyId, viewerId } },
        select: { id: true },
      });

      if (!existing) {
        await this.prisma.$transaction([
          this.prisma.storyView.create({ data: { storyId, viewerId } }),
          this.prisma.story.update({
            where: { id: storyId },
            data: { viewCount: { increment: 1 } },
          }),
        ]);
      }

      return {
        type: 'response',
        message: 'Story viewed',
        data: { success: true },
      };
    } catch (error) {
      handleDefaultError(error);
    }
  }

  async getStoryViewers({
    storyId,
    ownerId,
  }: {
    storyId: string;
    ownerId: string;
  }): Promise<
    IBeforeTransformResponseType<{ viewCount: number; viewers: UserDataType[] }>
  > {
    try {
      const story = await this.prisma.story.findUnique({
        where: { id: storyId },
        select: { id: true, authorId: true, viewCount: true },
      });
      if (!story) throw new NotFoundException('Story not found');
      if (story.authorId !== ownerId) {
        throw new ForbiddenException(
          'You can only see viewers of your own story',
        );
      }

      const views = await this.prisma.storyView.findMany({
        where: { storyId },
        orderBy: { createdAt: 'desc' },
        select: { viewer: { select: userDataSelect } },
      });

      return {
        type: 'response',
        message: 'Story viewers',
        data: {
          viewCount: story.viewCount,
          viewers: views.map((v) => v.viewer),
        },
      };
    } catch (error) {
      handleDefaultError(error);
    }
  }

  async deleteStory({
    storyId,
    userId,
  }: {
    storyId: string;
    userId: string;
  }): Promise<IBeforeTransformResponseType<{ success: boolean }>> {
    try {
      const story = await this.prisma.story.findUnique({
        where: { id: storyId },
        select: { id: true, authorId: true, mediaUrl: true },
      });
      if (!story) throw new NotFoundException('Story not found');
      if (story.authorId !== userId) {
        throw new ForbiddenException('This story is not yours');
      }

      await this.prisma.story.delete({ where: { id: storyId } });

      // Best-effort media cleanup.
      this.s3Service.deleteFile(story.mediaUrl).catch(() => undefined);

      return {
        type: 'response',
        message: 'Story deleted',
        data: { success: true },
      };
    } catch (error) {
      handleDefaultError(error);
    }
  }
}
