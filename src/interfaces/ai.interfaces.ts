export interface IAIMessageContentType {
  type: 'text';
  text: string;
}

export interface IAIMessagePromptType {
  role: 'system' | 'user' | 'assistant';
  content: string | IAIMessageContentType[];
}
