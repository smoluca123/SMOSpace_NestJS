import { Controller, Get, Query, UseGuards } from '@nestjs/common';
import { ApiBearerAuth, ApiHeader, ApiOperation, ApiQuery, ApiTags } from '@nestjs/swagger';
import { DecodedAccessToken } from 'src/decorators/decodedAccessToken.decorator';
import { JwtTokenVerifyGuard } from 'src/guards/jwt-token-verify.guard';
import { IDecodedAccecssTokenType } from 'src/interfaces/interfaces.global';
import { normalizePaginationParams } from 'src/utils/utils';
import { CallService } from './call.service';

@ApiTags('Call')
@Controller('call')
@ApiBearerAuth()
export class CallController {
  constructor(private readonly callService: CallService) {}

  /**
   * Returns the authenticated user's paginated call history.
   * Records come from SYSTEM chat messages produced by CallGateway when a call ends.
   */
  @Get('history')
  @ApiOperation({ summary: 'Get call history for the current user' })
  @ApiHeader({ name: 'accessToken', description: 'Access token', required: true })
  @ApiQuery({ name: 'page', required: false, type: Number })
  @ApiQuery({ name: 'limit', required: false, type: Number })
  @ApiQuery({
    name: 'filter',
    required: false,
    enum: ['all', 'audio', 'video', 'missed'],
  })
  @UseGuards(JwtTokenVerifyGuard)
  getCallHistory(
    @DecodedAccessToken() decodedAccessToken: IDecodedAccecssTokenType,
    @Query('page') _page?: string,
    @Query('limit') _limit?: string,
    @Query('filter') filter?: 'all' | 'audio' | 'video' | 'missed',
  ) {
    const { page, limit } = normalizePaginationParams({
      page: +_page,
      limit: +_limit,
    });

    return this.callService.getCallHistory({
      userId: decodedAccessToken.userId,
      page,
      limit,
      filter: filter || 'all',
    });
  }
}

