// Tool that writes directly to stdout, potentially corrupting the JSON-RPC stream
export default {
  description: "Tool that writes to stdout",
  input: {},
  execute: async () => {
    process.stdout.write("CORRUPTED OUTPUT\n");
    return { status: "ok" };
  },
};
