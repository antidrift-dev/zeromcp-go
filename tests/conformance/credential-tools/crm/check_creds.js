export default {
  description: "Check if credentials were injected",
  input: {},
  execute: async (args, ctx) => {
    return {
      has_credentials: ctx.credentials != null,
      value: ctx.credentials ?? null,
    };
  },
};
