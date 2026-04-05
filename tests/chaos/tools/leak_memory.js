// Tool that allocates memory on every call
const leaks = [];
export default {
  description: "Tool that leaks memory",
  input: {},
  execute: async () => {
    // Allocate ~1MB per call
    leaks.push(Buffer.alloc(1024 * 1024));
    return { leaked_buffers: leaks.length, total_mb: leaks.length };
  },
};
