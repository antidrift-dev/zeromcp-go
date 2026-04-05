export default {
  description: "Process a refund",
  input: {},
  execute: async () => ({ tool: 'billing_refund' }),
};
