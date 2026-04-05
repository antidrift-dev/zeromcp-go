tool description: "Fetch an allowed domain",
     input: {},
     permissions: { network: ["localhost"] }

execute do |args, ctx|
  if ZeroMcp::Sandbox.check_network_access(ctx.tool_name, "localhost", ctx.permissions)
    { "status" => "ok", "domain" => "localhost" }
  else
    { "status" => "error" }
  end
end
