import { Injectable } from '@nestjs/common';
import * as MailPace from '@mailpace/mailpace.js';
import * as handlebars from 'handlebars';
import * as fs from 'fs';
import * as path from 'path';
import { MailerService } from '@nestjs-modules/mailer';
import { ConfigService } from '@nestjs/config';
import { RateLimiterService } from 'src/common/services/rate-limiter.service';
import {
  EMAIL_RATE_LIMITS,
  RATE_LIMIT_KEY_PREFIXES,
} from 'src/common/constants/rate-limits.constants';

@Injectable()
export class EmailService {
  constructor(
    private mailerService: MailerService,
    private readonly config: ConfigService,
    private readonly rateLimiter: RateLimiterService,
  ) {}

  compileTemplate(templateName: string, context: any): string {
    const templatePath = path.join(
      __dirname,
      'templates',
      `${templateName}.hbs`,
    );
    const templateSource = fs.readFileSync(templatePath, 'utf-8');
    const template = handlebars.compile(templateSource);
    return template(context);
  }

  async sendEmail({
    from,
    to,
    subject,
    htmlbody,
  }: {
    from?: string;
    to: string;
    subject: string;
    htmlbody: string;
  }) {
    const defaultFrom = `${this.config.get('MAILER_FROM_NAME')} <${this.config.get('MAILER_FROM_ADDRESS')}>`;
    const emailFrom = from || defaultFrom;

    const fromArgs = emailFrom.split('@');
    const allowedDomain = this.config.get('MAILER_FROM_ADDRESS').split('@')[1];

    if (!fromArgs.pop().includes(allowedDomain))
      throw new Error('Mail is not supported');

    const client = new MailPace.DomainClient(this.config.get('MAILER_USER'));

    try {
      const data = await client.sendEmail({
        from: emailFrom,
        to,
        subject,
        htmlbody,
      });

      return data;
    } catch (error) {
      console.log(error);
      throw error;
    }
  }

  async sendActiveAccountEmail({
    email,
    context,
  }: {
    email: string;
    context: {
      name: string;
      verification_code: string;
      confirmationLink?: string;
    };
  }) {
    // Apply rate limiting per recipient email
    await this.rateLimiter.enforceLimit({
      key: `${RATE_LIMIT_KEY_PREFIXES.EMAIL_ACTIVATION}:${email}`,
      limit: EMAIL_RATE_LIMITS.ACTIVATION.limit,
      window: EMAIL_RATE_LIMITS.ACTIVATION.window,
    });

    await this.mailerService.sendMail({
      to: email,
      subject: `SMO - Active Account`,
      template: './register/html',
      context: {
        ...context,
        // confirmationLink: context.confirmationLink || '#',
      },
    });
  }

  async sendForgotPasswordEmail({
    email,
    context,
  }: {
    email: string;
    context: {
      name: string;
      verification_code: string;
      confirmationLink?: string;
    };
  }) {
    // Apply rate limiting per recipient email
    await this.rateLimiter.enforceLimit({
      key: `${RATE_LIMIT_KEY_PREFIXES.EMAIL_FORGOT_PASSWORD}:${email}`,
      limit: EMAIL_RATE_LIMITS.FORGOT_PASSWORD.limit,
      window: EMAIL_RATE_LIMITS.FORGOT_PASSWORD.window,
    });

    await this.mailerService.sendMail({
      to: email,
      subject: `SMO - Forgot Password`,
      template: './forgotpassword/html',
      context: {
        ...context,
        // confirmationLink: context.confirmationLink || '#',
      },
    });
  }
}
