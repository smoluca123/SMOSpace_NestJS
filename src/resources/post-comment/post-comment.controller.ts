import { Controller, UseGuards } from '@nestjs/common';
import { PostCommentService } from './post-comment.service';
import { ApiBearerAuth, ApiTags } from '@nestjs/swagger';
import { AuthGuard } from '@nestjs/passport';
import { RoleGuard } from 'src/guards/role.guard';

@ApiTags('Post Comment')
@ApiBearerAuth()
@UseGuards(AuthGuard('jwt'), RoleGuard)
@Controller('/post/comment')
export class PostCommentController {
  constructor(private readonly postCommentService: PostCommentService) {}
}
