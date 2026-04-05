using ZeroMcp;

var leaks = new List<byte[]>();
var server = new ZeroMcpServer();

server.Tool("hello", new ToolDefinition
{
    Description = "Say hello",
    Input = new Dictionary<string, InputField> { ["name"] = new InputField(SimpleType.String) },
    Execute = async (args, ctx) =>
    {
        var name = args["name"].GetString() ?? "world";
        return $"Hello, {name}!";
    }
});

server.Tool("throw_error", new ToolDefinition
{
    Description = "Tool that throws",
    Execute = async (args, ctx) => throw new Exception("Intentional chaos")
});

server.Tool("hang", new ToolDefinition
{
    Description = "Tool that hangs forever",
    Execute = async (args, ctx) => { await Task.Delay(Timeout.Infinite); return "unreachable"; }
});

server.Tool("slow", new ToolDefinition
{
    Description = "Tool that takes 3 seconds",
    Execute = async (args, ctx) => { await Task.Delay(3000); return new { status = "ok", delay_ms = 3000 }; }
});

server.Tool("leak_memory", new ToolDefinition
{
    Description = "Tool that leaks memory",
    Execute = async (args, ctx) =>
    {
        leaks.Add(new byte[1024 * 1024]);
        return new { leaked_buffers = leaks.Count, total_mb = leaks.Count };
    }
});

server.Tool("stdout_corrupt", new ToolDefinition
{
    Description = "Tool that writes to stdout",
    Execute = async (args, ctx) =>
    {
        Console.Out.WriteLine("CORRUPTED OUTPUT");
        Console.Out.Flush();
        return new { status = "ok" };
    }
});

await server.Serve();
