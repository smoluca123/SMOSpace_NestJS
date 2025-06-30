export interface IAIMessageContentType {
  type: 'text';
  text: string;
}

export interface IAIMessagePromptType {
  role: 'system' | 'user' | 'assistant';
  content: string | IAIMessageContentType[];
}

export interface IGenerateImagesResponseType {
  id: string;
  model: string;
  version: string;
  input: IGenerateImagesInput;
  output: {
    url: string;
  }[];
}

interface IGenerateImagesInput {
  prompt: string;
  image_size: {
    width: number;
    height: number;
  };
  num_inference_steps: number;
  num_images: number;
  seed: number;
  output_format: string;
  output_quality: number;
}
