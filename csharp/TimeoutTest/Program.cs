using ZeroMcp;

var server = new ZeroMcpServer();

server.Tool("hello", new ToolDefinition
{
    Description = "Fast tool",
    Input = new Dictionary<string, InputField> { ["name"] = new InputField(SimpleType.String) },
    Execute = async (args, ctx) =>
    {
        var name = args.ContainsKey("name") ? args["name"].GetString() ?? "world" : "world";
        return $"Hello, {name}!";
    }
});

server.Tool("slow", new ToolDefinition
{
    Description = "Tool that takes 3 seconds",
    Permissions = new Permissions { ExecuteTimeout = 2000 },
    Execute = async (args, ctx) =>
    {
        await Task.Delay(3000);
        return new { status = "ok" };
    }
});

await server.Serve();
