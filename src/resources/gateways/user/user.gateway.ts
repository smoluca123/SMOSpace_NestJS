import { RedisService } from '@liaoliaots/nestjs-redis';

import { OnModuleInit, UseGuards, UsePipes } from '@nestjs/common';
import {
  ConnectedSocket,
  MessageBody,
  OnGatewayDisconnect,
  SubscribeMessage,
  WebSocketGateway,
  WebSocketServer,
} from '@nestjs/websockets';

import { Redis } from 'ioredis';
import { Server, Socket } from 'socket.io';
import { WsJwtGuard } from 'src/guards/ws-auth.guard';
import { WsJwtVerifyGuard } from 'src/guards/ws-jwt-verify.guard';
import { SocketWithUserAndDecodedAccessToken } from 'src/interfaces/interfaces.global';
import { PrismaService } from 'src/prisma/prisma.service';
import { ZodValidationPipe } from 'src/pipes/zod.pipe';
import {
  UserOnline,
  UserOnlineSchema,
} from 'src/resources/gateways/user/schemas/user.schemas';

const ONLINE_HASH_KEY = 'users:online';

interface PresencePayload {
  userId: string;
  status: 'online' | 'away' | 'busy' | 'offline';
  isOnline: boolean;
}

@UseGuards(WsJwtGuard)
@WebSocketGateway({
  namespace: 'user',
  cors: {
    origin: '*',
  },
})
export class UserGateway implements OnGatewayDisconnect, OnModuleInit {
  @WebSocketServer()
  private server: Server;

  private redis: Redis | null;

  // userId -> set of socket ids. Allows a user to stay "online" while at least
  // one tab/device is still connected (multi-connection safety).
  private userSockets: Map<string, Set<string>> = new Map();

  constructor(
    private readonly redisService: RedisService,
    private readonly prisma: PrismaService,
  ) {
    this.redis = this.redisService.getOrThrow();
  }

  // Clear any stale presence left over from a previous (crashed) server run.
  async onModuleInit() {
    await this.redis.del(ONLINE_HASH_KEY);
  }

  @UseGuards(WsJwtVerifyGuard)
  @UsePipes(new ZodValidationPipe(UserOnlineSchema))
  @SubscribeMessage('user:online')
  async handleOnline(
    @MessageBody() data: UserOnline,
    @ConnectedSocket() client: SocketWithUserAndDecodedAccessToken,
  ) {
    const userId = client.data.user.id;
    const status = data.status || 'online';

    // Respect the user's privacy preference: when online status is hidden, do
    // not register or broadcast their presence. Reciprocally, they don't get to
    // see anyone else's presence either (return an empty snapshot).
    const dbUser = await this.prisma.user.findUnique({
      where: { id: userId },
      select: { showOnlineStatus: true },
    });
    if (dbUser && dbUser.showOnlineStatus === false) {
      client.emit('user:online:list', []);
      return { status: 'hidden' };
    }

    const sockets = this.userSockets.get(userId);
    const wasOffline = !sockets || sockets.size === 0;

    if (!sockets) {
      this.userSockets.set(userId, new Set([client.id]));
    } else {
      sockets.add(client.id);
    }

    await this.redis.hset(ONLINE_HASH_KEY, userId, JSON.stringify({ status }));

    // Broadcast the presence so every client reflects this user's latest status.
    // This is idempotent on the client side, so re-emitting for extra tabs or
    // status changes (online -> away) is safe.
    this.server.emit('user:presence:update', {
      userId,
      status,
      isOnline: true,
    } as PresencePayload);

    // Send the full snapshot of who is online back to the caller so a freshly
    // connected client can initialise its presence state.
    const onlineUsers = await this.getOnlineUsers();
    client.emit('user:online:list', onlineUsers);

    return { status: 'success', firstConnection: wasOffline };
  }

  @UseGuards(WsJwtVerifyGuard)
  @SubscribeMessage('user:getOnline')
  async handleGetOnline(
    @ConnectedSocket() client: SocketWithUserAndDecodedAccessToken,
  ) {
    // Hidden users don't get to see others' presence (reciprocal privacy).
    const dbUser = await this.prisma.user.findUnique({
      where: { id: client.data.user.id },
      select: { showOnlineStatus: true },
    });
    if (dbUser && dbUser.showOnlineStatus === false) {
      client.emit('user:online:list', []);
      return { status: 'hidden' };
    }

    const onlineUsers = await this.getOnlineUsers();
    client.emit('user:online:list', onlineUsers);
    return { status: 'success' };
  }

  handleDisconnect(client: SocketWithUserAndDecodedAccessToken | Socket) {
    const user = client.data?.user;
    if (!user) return;

    const userId = user.id;
    const sockets = this.userSockets.get(userId);
    if (!sockets) return;

    sockets.delete(client.id);
    if (sockets.size > 0) return;

    // Last connection for this user is gone -> mark offline and broadcast.
    this.userSockets.delete(userId);
    this.redis.hdel(ONLINE_HASH_KEY, userId);
    this.server.emit('user:presence:update', {
      userId,
      status: 'offline',
      isOnline: false,
    } as PresencePayload);
  }

  private async getOnlineUsers(): Promise<PresencePayload[]> {
    const all = await this.redis.hgetall(ONLINE_HASH_KEY);
    return Object.entries(all).map(([userId, value]) => {
      let status: PresencePayload['status'] = 'online';
      try {
        status = JSON.parse(value).status || 'online';
      } catch {
        status = 'online';
      }
      return { userId, status, isOnline: true };
    });
  }
}
