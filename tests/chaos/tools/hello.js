// Normal tool — used as health check between attacks
export default {
  description: "Say hello",
  input: { name: 'string' },
  execute: async ({ name }) => `Hello, ${name}!`,
};
