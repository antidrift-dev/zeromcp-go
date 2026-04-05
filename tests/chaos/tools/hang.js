// Tool that never returns
export default {
  description: "Tool that hangs forever",
  input: {},
  execute: async () => {
    await new Promise(() => {}); // never resolves
  },
};
