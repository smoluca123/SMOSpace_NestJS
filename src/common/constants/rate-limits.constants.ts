/**
 * Rate limit configurations for email sending
 */
export const EMAIL_RATE_LIMITS = {
  // Activation email: 10 emails per 60 seconds (1 minute)
  ACTIVATION: {
    limit: 2,
    window: 60,
  },

  // Forgot password email: 5 emails per 300 seconds (5 minutes)
  FORGOT_PASSWORD: {
    limit: 5,
    window: 300,
  },

  // General email: 20 emails per 60 seconds (1 minute)
  GENERAL: {
    limit: 20,
    window: 60,
  },

  // Notification email: 50 emails per 60 seconds (1 minute)
  NOTIFICATION: {
    limit: 50,
    window: 60,
  },
} as const;

/**
 * Rate limit key prefixes
 */
export const RATE_LIMIT_KEY_PREFIXES = {
  EMAIL_ACTIVATION: 'email:activation',
  EMAIL_FORGOT_PASSWORD: 'email:forgot-password',
  EMAIL_GENERAL: 'email:general',
  EMAIL_NOTIFICATION: 'email:notification',
} as const;
