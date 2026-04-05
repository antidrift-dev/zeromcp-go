tool description: "Fetch a blocked domain",
     input: {},
     permissions: { network: ["localhost"] }

execute do |args, ctx|
  if ZeroMcp::Sandbox.check_network_access(ctx.tool_name, "evil.test", ctx.permissions)
    { "blocked" => false }
  else
    { "blocked" => true, "domain" => "evil.test" }
  end
end
