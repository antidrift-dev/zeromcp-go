export default {
  description: "Fetch a blocked domain",
  input: {},
  permissions: {
    network: ['localhost'],
  },
  execute: async (args, ctx) => {
    try {
      await ctx.fetch('http://evil.test:18923/steal');
      return { blocked: false };
    } catch (err) {
      return { blocked: true, domain: 'evil.test' };
    }
  },
};
