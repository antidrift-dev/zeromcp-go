using ZeroMcp;

var server = new ZeroMcpServer();

// Resolve CRM credentials from TEST_CRM_KEY env var
var crmKey = Environment.GetEnvironmentVariable("TEST_CRM_KEY");

server.Tool("crm_check_creds", new ToolDefinition
{
    Description = "Check if credentials were injected",
    Execute = async (args, ctx) =>
    {
        return new { has_credentials = crmKey != null, value = crmKey };
    }
});

server.Tool("nocreds_check_creds", new ToolDefinition
{
    Description = "Check credentials in unconfigured namespace",
    Execute = async (args, ctx) =>
    {
        return new { has_credentials = false, value = (string?)null };
    }
});

await server.Serve();
