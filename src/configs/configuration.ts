const configuration = () => ({
  SERVER_PORT: parseInt(process.env.SERVER_PORT || '0', 10) || 8080,
});

export default configuration;
