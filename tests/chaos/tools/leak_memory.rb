$leaks = []

tool description: "Tool that leaks memory",
     input: {}

execute do |args, ctx|
  $leaks << ("\x00" * 1024 * 1024)
  { "leaked_buffers" => $leaks.size, "total_mb" => $leaks.size }
end
