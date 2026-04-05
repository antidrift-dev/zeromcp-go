tool description: "Fast tool",
     input: { name: "string" }

execute do |args, ctx|
  "Hello, #{args['name']}!"
end
