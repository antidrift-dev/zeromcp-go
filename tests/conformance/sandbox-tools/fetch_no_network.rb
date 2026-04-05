tool description: "Tool with network disabled",
     input: {},
     permissions: { network: false }

execute do |args, ctx|
  if ZeroMcp::Sandbox.check_network_access(ctx.tool_name, "localhost", ctx.permissions)
    { "blocked" => false }
  else
    { "blocked" => true }
  end
end
