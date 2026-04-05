// Tool that takes a long time but eventually returns
export default {
  description: "Tool that takes 3 seconds",
  input: {},
  execute: async () => {
    await new Promise(r => setTimeout(r, 3000));
    return { status: "ok", delay_ms: 3000 };
  },
};
