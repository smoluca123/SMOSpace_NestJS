import OpenAI from 'openai';
import { configData } from 'src/configs/configuration';

const openai = new OpenAI({
  baseURL: configData.OPENROUTER_PROVIDER_URL,
  apiKey: configData.OPENROUTER_API_KEY,
});

export default openai;
