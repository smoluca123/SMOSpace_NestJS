import {
  Controller,
  Post,
  Body,
  UseGuards,
  Get,
  Param,
  Query,
} from '@nestjs/common';
import { ChatService } from './chat.service';
import { CreateFirstMessageDto } from './dto/create-message.dto';
import { AuthGuard } from '@nestjs/passport';
import {
  createDirectChatDecorator,
  getUserRoomsDecorator,
} from 'src/resources/chat/chat.decorators';
import { ApiBearerAuth, ApiTags } from '@nestjs/swagger';
import { DecodedAccessToken } from 'src/decorators/decodedAccessToken.decorator';
import { IDecodedAccecssTokenType } from 'src/interfaces/interfaces.global';
import { normalizePaginationParams } from 'src/utils/utils';

@ApiTags('Chat Management')
@Controller('chat')
@ApiBearerAuth()
@UseGuards(AuthGuard('jwt'))
export class ChatController {
  constructor(private readonly chatService: ChatService) {}

  @Post('direct/:userId')
  @createDirectChatDecorator()
  async createDirectChat(
    @DecodedAccessToken() decodedAccessToken: IDecodedAccecssTokenType,
    @Param('userId') targetUserId: string,
    @Body() createFirstMessageDto: CreateFirstMessageDto,
  ) {
    const { userId } = decodedAccessToken;
    // Create or get existing direct chat room
    const room = await this.chatService.handleCreateDirectChatRoom({
      userId1: userId,
      userId2: targetUserId,
    });

    // Send the first message
    const message = await this.chatService.handleCreateMessage(userId, {
      ...createFirstMessageDto,
      roomId: room.id,
    });

    return {
      room,
      message,
    };
  }

  @Get('active-rooms')
  @getUserRoomsDecorator()
  async getUserRooms(
    @DecodedAccessToken() decodedAccessToken: IDecodedAccecssTokenType,
    @Query('limit') _limit?: string,
    @Query('page') _page?: string,
  ) {
    const { userId } = decodedAccessToken;
    const { limit, page } = normalizePaginationParams({
      limit: +_limit,
      page: +_page,
    });
    return this.chatService.getUserActiveRooms({
      userId,
      limit,
      page,
    });
  }

  @Get('rooms/:roomId/messages')
  async getRoomMessages(
    @Param('roomId') roomId: string,
    @Query('limit') _limit?: string,
    @Query('page') _page?: string,
    @Query('before') before?: string,
  ) {
    const { limit, page } = normalizePaginationParams({
      limit: +_limit,
      page: +_page,
    });
    return this.chatService.getRoomMessages({
      roomId,
      limit,
      page,
      before: before ? new Date(before) : undefined,
    });
  }

  @Get('rooms/:roomId/participants')
  async getRoomParticipants(
    @Param('roomId') roomId: string,
    @Query('limit') _limit?: string,
    @Query('page') _page?: string,
  ) {
    const { limit, page } = normalizePaginationParams({
      limit: +_limit,
      page: +_page,
    });
    return this.chatService.getRoomParticipants({
      roomId,
      limit,
      page,
    });
  }
}
