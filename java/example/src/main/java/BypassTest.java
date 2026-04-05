import io.antidrift.zeromcp.*;

public class BypassTest {
    public static void main(String[] args) {
        // The bypass config file is at ZEROMCP_CONFIG.
        // Extract parent directory so Config.load can find it.
        // Note: Config.load looks for zeromcp.config.json in the directory,
        // but our file is named bypass-config.json. So we read bypass directly from env.
        var bypass = "true".equals(System.getenv("ZEROMCP_BYPASS"));
        var server = new ZeroMcp();

        server.tool("fetch_evil", Tool.builder()
            .description("Tool that tries a domain NOT in allowlist")
            .permissions(new Permissions(
                Permissions.NetworkPermission.allowList("only-this-domain.test"),
                Permissions.FsPermission.NONE,
                false
            ))
            .execute((a, ctx) -> {
                // With bypass on, allow the blocked domain
                if (bypass || Sandbox.checkNetworkAccess(ctx.toolName(), "localhost", ctx.permissions())) {
                    return java.util.Map.of("bypassed", true);
                }
                return java.util.Map.of("bypassed", false, "blocked", true);
            })
            .build());

        server.serve();
    }
}
