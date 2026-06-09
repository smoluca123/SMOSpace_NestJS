import { Injectable, Logger, OnModuleInit } from '@nestjs/common';
import { ConfigService } from '@nestjs/config';
import * as webpush from 'web-push';
import { PrismaService } from 'src/prisma/prisma.service';

export interface PushPayload {
  title: string;
  body: string;
  icon?: string;
  url?: string;
  tag?: string;
}

export interface SaveSubscriptionInput {
  endpoint: string;
  keys: { p256dh: string; auth: string };
}

/**
 * Web Push (browser Push API) delivery. Stores per-user subscriptions and sends
 * encrypted pushes via VAPID. Reaches users even when the tab/app is closed -
 * complementing the in-app Socket.IO notifications which only fire while online.
 */
@Injectable()
export class PushService implements OnModuleInit {
  private readonly logger = new Logger(PushService.name);
  private configured = false;

  constructor(
    private readonly prisma: PrismaService,
    private readonly configService: ConfigService,
  ) {}

  onModuleInit() {
    const publicKey = this.configService.get<string>(
      'WEBPUSH_VAPID_PUBLIC_KEY',
    );
    const privateKey = this.configService.get<string>(
      'WEBPUSH_VAPID_PRIVATE_KEY',
    );
    const subject =
      this.configService.get<string>('WEBPUSH_VAPID_SUBJECT') ||
      'mailto:admin@example.com';

    if (publicKey && privateKey) {
      webpush.setVapidDetails(subject, publicKey, privateKey);
      this.configured = true;
    } else {
      this.logger.warn(
        'Web Push disabled: set WEBPUSH_VAPID_PUBLIC_KEY and WEBPUSH_VAPID_PRIVATE_KEY to enable.',
      );
    }
  }

  isConfigured(): boolean {
    return this.configured;
  }

  getPublicKey(): string | null {
    return this.configService.get<string>('WEBPUSH_VAPID_PUBLIC_KEY') ?? null;
  }

  /** Store (or refresh) a browser subscription for a user. */
  async saveSubscription(
    userId: string,
    sub: SaveSubscriptionInput,
    userAgent?: string,
  ): Promise<void> {
    await this.prisma.pushSubscription.upsert({
      where: { endpoint: sub.endpoint },
      create: {
        userId,
        endpoint: sub.endpoint,
        p256dh: sub.keys.p256dh,
        auth: sub.keys.auth,
        userAgent,
      },
      update: {
        userId,
        p256dh: sub.keys.p256dh,
        auth: sub.keys.auth,
        userAgent,
      },
    });
  }

  async removeSubscription(endpoint: string): Promise<void> {
    await this.prisma.pushSubscription
      .delete({ where: { endpoint } })
      .catch(() => undefined);
  }

  /** Fire-and-forget push to every device a user has registered. */
  async sendToUser(userId: string, payload: PushPayload): Promise<void> {
    if (!this.configured) return;

    const subscriptions = await this.prisma.pushSubscription.findMany({
      where: { userId },
    });
    if (subscriptions.length === 0) return;

    const body = JSON.stringify(payload);

    await Promise.all(
      subscriptions.map(async (sub) => {
        try {
          await webpush.sendNotification(
            {
              endpoint: sub.endpoint,
              keys: { p256dh: sub.p256dh, auth: sub.auth },
            },
            body,
          );
        } catch (error: unknown) {
          // 404/410 mean the subscription is gone - prune it.
          const statusCode = (error as { statusCode?: number })?.statusCode;
          if (statusCode === 404 || statusCode === 410) {
            await this.removeSubscription(sub.endpoint);
          } else {
            this.logger.warn(
              `Push to ${sub.endpoint} failed: ${String(error)}`,
            );
          }
        }
      }),
    );
  }
}
