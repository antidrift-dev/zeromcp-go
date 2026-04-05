tool description: "Check if credentials were injected",
     input: {}

execute do |args, ctx|
  {
    "has_credentials" => !ctx.credentials.nil?,
    "value" => ctx.credentials,
  }
end
