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
  ForwardMessageDto,
  ReactToMessageDto,
  SharePostToChatDto,
} from './dto/create-message.dto';
import { AuthGuard } from '@nestjs/passport';
import {
  chatEndpointDecorator,
  chatPaginatedEndpointDecorator,
  createDirectChatDecorator,
  forwardMessageDecorator,
  getRoomMessagesDecorator,
  getShareRecipientsDecorator,
  getUserRoomsDecorator,
  sharePostToChatDecorator,
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

  @Post('rooms/:roomId/file')
  @chatEndpointDecorator('Send a file message')
  @UseInterceptors(
    FileInterceptor('file', {
      limits: { fileSize: 1024 * 1024 * 25 }, // 25MB
    }),
  )
  async sendFileMessage(
    @DecodedAccessToken() decodedAccessToken: IDecodedAccecssTokenType,
    @Param('roomId') roomId: string,
    @UploadedFile() file: Express.Multer.File,
  ) {
    const message = await this.chatService.handleCreateFileMessage(
      decodedAccessToken.userId,
      roomId,
      file,
    );
    await this.chatGateway.broadcastMessage(message, decodedAccessToken.userId);
    return {
      type: 'response',
      message: 'File message sent',
      data: message,
    } satisfies IBeforeTransformResponseType<ChatMessageDataType>;
  }

  @Post('rooms/:roomId/voice')
  @chatEndpointDecorator('Send a voice message')
  @UseInterceptors(
    FileInterceptor('audio', {
      limits: { fileSize: 1024 * 1024 * 15 }, // 15MB
    }),
  )
  async sendVoiceMessage(
    @DecodedAccessToken() decodedAccessToken: IDecodedAccecssTokenType,
    @Param('roomId') roomId: string,
    @UploadedFile() audio: Express.Multer.File,
    @Body('duration') duration?: string,
  ) {
    const message = await this.chatService.handleCreateVoiceMessage(
      decodedAccessToken.userId,
      roomId,
      audio,
      duration ? Math.round(+duration) : 0,
    );
    await this.chatGateway.broadcastMessage(message, decodedAccessToken.userId);
    return {
      type: 'response',
      message: 'Voice message sent',
      data: message,
    } satisfies IBeforeTransformResponseType<ChatMessageDataType>;
  }

  @Get('share-recipients')
  @getShareRecipientsDecorator()
  getShareRecipients(
    @DecodedAccessToken() decodedAccessToken: IDecodedAccecssTokenType,
    @Query('search') search?: string,
    @Query('limit') _limit?: string,
    @Query('page') _page?: string,
  ) {
    const { limit, page } = normalizePaginationParams({
      limit: +_limit,
      page: +_page,
    });
    return this.chatService.getShareRecipients({
      userId: decodedAccessToken.userId,
      search,
      limit,
      page,
    });
  }

  @Post('share-post/:postId')
  @sharePostToChatDecorator()
  async sharePostToChat(
    @DecodedAccessToken() decodedAccessToken: IDecodedAccecssTokenType,
    @Param('postId') postId: string,
    @Body() body: SharePostToChatDto,
  ) {
    const result = await this.chatService.sharePostToChats({
      userId: decodedAccessToken.userId,
      postId,
      roomIds: body.roomIds,
      userIds: body.userIds,
    });

    // Broadcast each created message to its room + recipients.
    await Promise.all(
      result.data.map((message) =>
        this.chatGateway.broadcastMessage(message, decodedAccessToken.userId),
      ),
    );

    return result;
  }

  @Post('messages/:messageId/forward')
  @forwardMessageDecorator()
  async forwardMessage(
    @DecodedAccessToken() decodedAccessToken: IDecodedAccecssTokenType,
    @Param('messageId') messageId: string,
    @Body() body: ForwardMessageDto,
  ) {
    const result = await this.chatService.forwardMessage({
      userId: decodedAccessToken.userId,
      messageId,
      roomIds: body.roomIds,
    });

    await Promise.all(
      result.data.map((message) =>
        this.chatGateway.broadcastMessage(message, decodedAccessToken.userId),
      ),
    );

    return result;
  }

  @Post('messages/:messageId/react')
  @chatEndpointDecorator('Toggle a reaction on a chat message')
  async reactToMessage(
    @DecodedAccessToken() decodedAccessToken: IDecodedAccecssTokenType,
    @Param('messageId') messageId: string,
    @Body() body: ReactToMessageDto,
  ) {
    const result = await this.chatService.reactToMessage({
      userId: decodedAccessToken.userId,
      messageId,
      type: body.type,
    });

    // Broadcast the updated message so every participant in the room gets a
    // fresh reaction snapshot in real time.
    const roomId = result.data.message.room?.id;
    if (roomId) {
      this.chatGateway.emitMessageReactionUpdated(roomId, result.data.message);
    }

    return result;
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
