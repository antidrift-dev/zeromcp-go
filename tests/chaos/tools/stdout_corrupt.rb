tool description: "Tool that writes to stdout",
     input: {}

execute do |args, ctx|
  $stdout.puts "CORRUPTED OUTPUT"
  $stdout.flush
  { "status" => "ok" }
end
