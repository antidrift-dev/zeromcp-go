tool description: "Tool that tries a domain NOT in allowlist",
     input: {},
     permissions: { network: ["only-this-domain.test"] }

execute do |args, ctx|
  if ZeroMcp::Sandbox.check_network_access(ctx.tool_name, "localhost", ctx.permissions)
    { "bypassed" => true }
  else
    { "bypassed" => false, "blocked" => true }
  end
end
