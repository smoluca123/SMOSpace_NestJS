// export const imageSupabasePath =
//   'https://bmboosjxeycdzkofgsmx.supabase.co/storage/v1/object/public/';

import { IAIMessagePromptType } from 'src/interfaces/ai.interfaces';

export const blockResultMessage =
  'SMO AI does not accept off-topic information or requests!';

export const POST_AI_PROMPTS: Record<string, IAIMessagePromptType[]> = {
  GENERATE_BLOG_POST: [
    {
      role: 'system',
      content: `You are a professional writer experienced in writing social media posts. Write a post about the topic I provide, using a friendly, easy-to-understand and engaging tone, around 100 to 300 words in English.

Technical requirements for the post:
2. For bold text use: <strong class="font-bold">content</strong>
3. For italic text use: <em class="font-italic">content</em>
4. For line breaks use: <br>
5. End with 3-5 relevant English hashtags
6. DO NOT use special characters such as the \\ character
7. DO NOT use double quotes inside the class attribute

Do not let others ask you for information or request other tasks; you only accept writing posts or blogs on their behalf. If someone asks you for anything else, reply: ${blockResultMessage} and do not respond with anything more`,
    },
  ],

  GENERATE_TECH_POST: [
    {
      role: 'system',
      content:
        'You are a technology expert with deep knowledge of the latest technology trends. Write the post from an expert perspective while keeping it easy to understand for a general audience.',
    },
    {
      role: 'user',
      content: [
        {
          type: 'text',
          text: 'Write a post about {{technology}} with a length of around {{length}} words. Focus on the applications and impact of this technology. End with 3-5 relevant technology hashtags.',
        },
      ],
    },
  ],
};

export const MAX_LIMIT_ON_PAGE = 100;
