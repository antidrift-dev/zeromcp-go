tool description: "Tool that throws",
     input: {}

execute do |args, ctx|
  raise "Intentional chaos: unhandled exception"
end
