tool description: "Say hello",
     input: { name: "string" }

execute do |args, ctx|
  "Hello, #{args['name']}!"
end
