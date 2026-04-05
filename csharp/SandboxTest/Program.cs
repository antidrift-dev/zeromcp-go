using ZeroMcp;

var server = new ZeroMcpServer();

server.Tool("fetch_allowed", new ToolDefinition
{
    Description = "Fetch an allowed domain",
    Permissions = new Permissions { Network = new[] { "localhost" } },
    Execute = async (args, ctx) =>
    {
        if (Sandbox.CheckNetworkAccess(ctx.ToolName, "localhost", ctx.Permissions))
            return new { status = "ok", domain = "localhost" };
        return new { status = "error" };
    }
});

server.Tool("fetch_blocked", new ToolDefinition
{
    Description = "Fetch a blocked domain",
    Permissions = new Permissions { Network = new[] { "localhost" } },
    Execute = async (args, ctx) =>
    {
        if (Sandbox.CheckNetworkAccess(ctx.ToolName, "evil.test", ctx.Permissions))
            return new { blocked = false };
        return new { blocked = true, domain = "evil.test" };
    }
});

server.Tool("fetch_no_network", new ToolDefinition
{
    Description = "Tool with network disabled",
    Permissions = new Permissions { Network = false },
    Execute = async (args, ctx) =>
    {
        if (Sandbox.CheckNetworkAccess(ctx.ToolName, "localhost", ctx.Permissions))
            return new { blocked = false };
        return new { blocked = true };
    }
});

server.Tool("fetch_unrestricted", new ToolDefinition
{
    Description = "Tool with no network restrictions",
    Execute = async (args, ctx) =>
    {
        if (Sandbox.CheckNetworkAccess(ctx.ToolName, "localhost", ctx.Permissions))
            return new { status = "ok", domain = "localhost" };
        return new { status = "error" };
    }
});

server.Tool("fetch_wildcard", new ToolDefinition
{
    Description = "Tool with wildcard network permission",
    Permissions = new Permissions { Network = new[] { "*.localhost" } },
    Execute = async (args, ctx) =>
    {
        if (Sandbox.CheckNetworkAccess(ctx.ToolName, "localhost", ctx.Permissions))
            return new { status = "ok", domain = "localhost" };
        return new { status = "error" };
    }
});

await server.Serve();
