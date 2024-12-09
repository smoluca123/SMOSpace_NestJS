import { envSchema } from './../utils/validations';
const configuration = () => ({
  SERVER_PORT: parseInt(process.env.SERVER_PORT || '0', 10) || 8080,
});

const validConfig = envSchema.safeParse(configuration());

if (validConfig.error) {
  throw new Error(validConfig.error.message);
}

const { data: configData } = validConfig;
export { configData };

export default configuration;
