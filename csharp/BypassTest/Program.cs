using ZeroMcp;

var bypass = Environment.GetEnvironmentVariable("ZEROMCP_BYPASS") == "true";
var server = new ZeroMcpServer();

server.Tool("fetch_evil", new ToolDefinition
{
    Description = "Tool that tries a domain NOT in allowlist",
    Permissions = new Permissions { Network = new[] { "only-this-domain.test" } },
    Execute = async (args, ctx) =>
    {
        // With bypass on, allow the blocked domain
        if (bypass || Sandbox.CheckNetworkAccess(ctx.ToolName, "localhost", ctx.Permissions))
            return new { bypassed = true };
        return new { bypassed = false, blocked = true };
    }
});

await server.Serve();
