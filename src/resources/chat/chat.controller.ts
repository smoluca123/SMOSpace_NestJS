import {
  Controller,
  Post,
  Body,
  UseGuards,
  Get,
  Param,
  Query,
  Delete,
  UploadedFile,
  UseInterceptors,
} from '@nestjs/common';
import { FileInterceptor } from '@nestjs/platform-express';
import { ChatService } from './chat.service';
import { ChatGateway } from './chat.gateway';
import {
  CreateFirstMessageDto,
  CreateGroupDto,
} from './dto/create-message.dto';
import { AuthGuard } from '@nestjs/passport';
import {
  chatEndpointDecorator,
  chatPaginatedEndpointDecorator,
  createDirectChatDecorator,
  getRoomMessagesDecorator,
  getUserRoomsDecorator,
} from 'src/resources/chat/chat.decorators';
import { ApiBearerAuth, ApiTags } from '@nestjs/swagger';
import { DecodedAccessToken } from 'src/decorators/decodedAccessToken.decorator';
import {
  IBeforeTransformResponseType,
  IDecodedAccecssTokenType,
} from 'src/interfaces/interfaces.global';
import { normalizePaginationParams } from 'src/utils/utils';
import { ChatMessageDataType } from 'src/libs/prisma-types';

@ApiTags('Chat Management')
@Controller('chat')
@ApiBearerAuth()
@UseGuards(AuthGuard('jwt'))
export class ChatController {
  constructor(
    private readonly chatService: ChatService,
    private readonly chatGateway: ChatGateway,
  ) {}

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

  @Post('direct-room/:userId')
  @createDirectChatDecorator()
  async createOrGetDirectRoom(
    @DecodedAccessToken() decodedAccessToken: IDecodedAccecssTokenType,
    @Param('userId') targetUserId: string,
  ) {
    const room = await this.chatService.handleCreateDirectChatRoom({
      userId1: decodedAccessToken.userId,
      userId2: targetUserId,
    });
    return {
      type: 'response',
      message: 'Direct chat room ready',
      data: room,
    } satisfies IBeforeTransformResponseType<typeof room>;
  }

  @Post('group')
  @chatEndpointDecorator('Create group chat')
  async createGroupChat(
    @DecodedAccessToken() decodedAccessToken: IDecodedAccecssTokenType,
    @Body() createGroupDto: CreateGroupDto,
  ) {
    const room = await this.chatService.handleCreateGroupChatRoom(
      createGroupDto.name,
      decodedAccessToken.userId,
      createGroupDto.participantIds,
    );
    return {
      type: 'response',
      message: 'Group chat created',
      data: room,
    } satisfies IBeforeTransformResponseType<typeof room>;
  }

  @Post('rooms/:roomId/messages')
  @chatEndpointDecorator('Send a text message')
  async sendMessage(
    @DecodedAccessToken() decodedAccessToken: IDecodedAccecssTokenType,
    @Param('roomId') roomId: string,
    @Body() body: CreateFirstMessageDto,
  ) {
    const message = await this.chatService.handleCreateMessage(
      decodedAccessToken.userId,
      {
        roomId,
        content: body.content,
        type: body.type,
        replyToId: body.replyToId,
      },
    );
    await this.chatGateway.broadcastMessage(message, decodedAccessToken.userId);
    return {
      type: 'response',
      message: 'Message sent',
      data: message,
    } satisfies IBeforeTransformResponseType<ChatMessageDataType>;
  }

  @Post('rooms/:roomId/image')
  @chatEndpointDecorator('Send an image message')
  @UseInterceptors(
    FileInterceptor('image', {
      limits: { fileSize: 1024 * 1024 * 10 }, // 10MB
    }),
  )
  async sendImageMessage(
    @DecodedAccessToken() decodedAccessToken: IDecodedAccecssTokenType,
    @Param('roomId') roomId: string,
    @UploadedFile() image: Express.Multer.File,
  ) {
    const message = await this.chatService.handleCreateImageMessage(
      decodedAccessToken.userId,
      roomId,
      image,
    );
    await this.chatGateway.broadcastMessage(message, decodedAccessToken.userId);
    return {
      type: 'response',
      message: 'Image message sent',
      data: message,
    } satisfies IBeforeTransformResponseType<ChatMessageDataType>;
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

  @Get('unread-count')
  @chatEndpointDecorator('Get total unread message count')
  getUnreadCount(
    @DecodedAccessToken() decodedAccessToken: IDecodedAccecssTokenType,
  ) {
    return this.chatService.getUnreadCount(decodedAccessToken.userId);
  }

  @Get('message-requests/count')
  @chatEndpointDecorator('Get pending message request count')
  getMessageRequestCount(
    @DecodedAccessToken() decodedAccessToken: IDecodedAccecssTokenType,
  ) {
    return this.chatService.getMessageRequestCount(decodedAccessToken.userId);
  }

  @Get('message-requests')
  @chatPaginatedEndpointDecorator('Get pending message requests')
  getMessageRequests(
    @DecodedAccessToken() decodedAccessToken: IDecodedAccecssTokenType,
    @Query('limit') _limit?: string,
    @Query('page') _page?: string,
  ) {
    const { limit, page } = normalizePaginationParams({
      limit: +_limit,
      page: +_page,
    });
    return this.chatService.getMessageRequests({
      userId: decodedAccessToken.userId,
      limit,
      page,
    });
  }

  @Post('rooms/:roomId/accept')
  @chatEndpointDecorator('Accept a message request')
  acceptMessageRequest(
    @DecodedAccessToken() decodedAccessToken: IDecodedAccecssTokenType,
    @Param('roomId') roomId: string,
  ) {
    return this.chatService.acceptMessageRequest(
      decodedAccessToken.userId,
      roomId,
    );
  }

  @Post('rooms/:roomId/reject')
  @chatEndpointDecorator('Reject a message request')
  rejectMessageRequest(
    @DecodedAccessToken() decodedAccessToken: IDecodedAccecssTokenType,
    @Param('roomId') roomId: string,
  ) {
    return this.chatService.rejectMessageRequest(
      decodedAccessToken.userId,
      roomId,
    );
  }

  @Post('rooms/:roomId/read')
  @chatEndpointDecorator('Mark a room as read')
  async markRoomAsRead(
    @DecodedAccessToken() decodedAccessToken: IDecodedAccecssTokenType,
    @Param('roomId') roomId: string,
  ) {
    const result = await this.chatService.markRoomAsRead(
      decodedAccessToken.userId,
      roomId,
    );
    // Notify the room (sender) in realtime so read receipts update live
    this.chatGateway.emitMessagesRead(roomId, decodedAccessToken.userId);
    return result;
  }

  @Post('rooms/:roomId/unread')
  @chatEndpointDecorator('Mark a room as unread')
  markRoomAsUnread(
    @DecodedAccessToken() decodedAccessToken: IDecodedAccecssTokenType,
    @Param('roomId') roomId: string,
  ) {
    return this.chatService.markRoomAsUnread(decodedAccessToken.userId, roomId);
  }

  @Post('rooms/:roomId/mute')
  @chatEndpointDecorator('Toggle room mute state')
  toggleMuteRoom(
    @DecodedAccessToken() decodedAccessToken: IDecodedAccecssTokenType,
    @Param('roomId') roomId: string,
  ) {
    return this.chatService.toggleMuteRoom(decodedAccessToken.userId, roomId);
  }

  @Delete('rooms/:roomId')
  @chatEndpointDecorator('Delete (leave) a conversation')
  deleteConversation(
    @DecodedAccessToken() decodedAccessToken: IDecodedAccecssTokenType,
    @Param('roomId') roomId: string,
  ) {
    return this.chatService.deleteConversation(
      decodedAccessToken.userId,
      roomId,
    );
  }

  @Get('rooms/:roomId/messages')
  @getRoomMessagesDecorator()
  getRoomMessages(
    @DecodedAccessToken() decodedAccessToken: IDecodedAccecssTokenType,
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
      userId: decodedAccessToken.userId,
      roomId,
      limit,
      page,
      before: before ? new Date(before) : undefined,
    });
  }

  @Get('rooms/:roomId/participants')
  @chatPaginatedEndpointDecorator('Get room participants')
  getRoomParticipants(
    @DecodedAccessToken() decodedAccessToken: IDecodedAccecssTokenType,
    @Param('roomId') roomId: string,
    @Query('limit') _limit?: string,
    @Query('page') _page?: string,
  ) {
    const { limit, page } = normalizePaginationParams({
      limit: +_limit,
      page: +_page,
    });
    return this.chatService.getRoomParticipants({
      userId: decodedAccessToken.userId,
      roomId,
      limit,
      page,
    });
  }
}
