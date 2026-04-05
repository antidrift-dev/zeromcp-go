tool description: "Tool that takes 3 seconds",
     input: {},
     permissions: { execute_timeout: 2 }

execute do |args, ctx|
  sleep(3)
  { "status" => "ok" }
end
