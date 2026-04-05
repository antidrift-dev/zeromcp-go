import io.antidrift.zeromcp.*;

public class SandboxTest {
    public static void main(String[] args) {
        var server = new ZeroMcp();

        server.tool("fetch_allowed", Tool.builder()
            .description("Fetch an allowed domain")
            .permissions(new Permissions(
                Permissions.NetworkPermission.allowList("localhost"),
                Permissions.FsPermission.NONE,
                false
            ))
            .execute((a, ctx) -> {
                if (Sandbox.checkNetworkAccess(ctx.toolName(), "localhost", ctx.permissions())) {
                    return java.util.Map.of("status", "ok", "domain", "localhost");
                }
                return java.util.Map.of("status", "error");
            })
            .build());

        server.tool("fetch_blocked", Tool.builder()
            .description("Fetch a blocked domain")
            .permissions(new Permissions(
                Permissions.NetworkPermission.allowList("localhost"),
                Permissions.FsPermission.NONE,
                false
            ))
            .execute((a, ctx) -> {
                if (Sandbox.checkNetworkAccess(ctx.toolName(), "evil.test", ctx.permissions())) {
                    return java.util.Map.of("blocked", false);
                }
                return java.util.Map.of("blocked", true, "domain", "evil.test");
            })
            .build());

        server.tool("fetch_no_network", Tool.builder()
            .description("Tool with network disabled")
            .permissions(new Permissions(
                Permissions.NetworkPermission.denied(),
                Permissions.FsPermission.NONE,
                false
            ))
            .execute((a, ctx) -> {
                if (Sandbox.checkNetworkAccess(ctx.toolName(), "localhost", ctx.permissions())) {
                    return java.util.Map.of("blocked", false);
                }
                return java.util.Map.of("blocked", true);
            })
            .build());

        server.tool("fetch_unrestricted", Tool.builder()
            .description("Tool with no network restrictions")
            .execute((a, ctx) -> {
                if (Sandbox.checkNetworkAccess(ctx.toolName(), "localhost", ctx.permissions())) {
                    return java.util.Map.of("status", "ok", "domain", "localhost");
                }
                return java.util.Map.of("status", "error");
            })
            .build());

        server.tool("fetch_wildcard", Tool.builder()
            .description("Tool with wildcard network permission")
            .permissions(new Permissions(
                Permissions.NetworkPermission.allowList("*.localhost"),
                Permissions.FsPermission.NONE,
                false
            ))
            .execute((a, ctx) -> {
                if (Sandbox.checkNetworkAccess(ctx.toolName(), "localhost", ctx.permissions())) {
                    return java.util.Map.of("status", "ok", "domain", "localhost");
                }
                return java.util.Map.of("status", "error");
            })
            .build());

        server.serve();
    }
}
