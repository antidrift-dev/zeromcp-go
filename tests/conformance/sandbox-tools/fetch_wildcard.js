export default {
  description: "Tool with wildcard network permission",
  input: {},
  permissions: {
    network: ['*.localhost'],
  },
  execute: async (args, ctx) => {
    try {
      const res = await ctx.fetch('http://localhost:18923/test');
      const body = await res.text();
      return { status: 'ok', domain: 'localhost' };
    } catch (err) {
      return { status: 'error', message: err.message };
    }
  },
};
