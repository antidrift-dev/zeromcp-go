export default {
  description: "Tool with network disabled",
  input: {},
  permissions: {
    network: false,
  },
  execute: async (args, ctx) => {
    try {
      await ctx.fetch('http://localhost:18923/test');
      return { blocked: false };
    } catch (err) {
      return { blocked: true };
    }
  },
};
