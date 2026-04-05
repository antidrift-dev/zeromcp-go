tool description: "Tool that takes 3 seconds",
     input: {}

execute do |args, ctx|
  sleep 3
  { "status" => "ok", "delay_ms" => 3000 }
end
