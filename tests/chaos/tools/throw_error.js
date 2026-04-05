// Tool that throws an unhandled exception
export default {
  description: "Tool that throws",
  input: {},
  execute: async () => {
    throw new Error("Intentional chaos: unhandled exception");
  },
};
