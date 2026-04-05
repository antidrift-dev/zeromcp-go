export default {
  description: "Check credentials in unconfigured namespace",
  input: {},
  execute: async (args, ctx) => {
    return {
      has_credentials: ctx.credentials != null,
      value: ctx.credentials ?? null,
    };
  },
};
