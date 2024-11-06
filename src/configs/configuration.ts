const configuration = () => ({
  SERVER_PORT: parseInt(process.env.SERVER_PORT || '0', 10) || 8080,
  FRONTEND_URL1: process.env.FRONTEND_URL1 || '',
  FRONTEND_URL2: process.env.FRONTEND_URL2 || '',
  FRONTEND_URL3: process.env.FRONTEND_URL3 || '',
  FRONTEND_URL4: process.env.FRONTEND_URL4 || '',
});

export default configuration;
