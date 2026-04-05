tool description: "Check credentials in unconfigured namespace",
     input: {}

execute do |args, ctx|
  {
    "has_credentials" => !ctx.credentials.nil?,
    "value" => ctx.credentials,
  }
end
