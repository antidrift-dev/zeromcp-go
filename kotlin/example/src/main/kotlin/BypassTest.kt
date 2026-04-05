import io.antidrift.zeromcp.*

fun bypassTestMain() {
    val bypass = System.getenv("ZEROMCP_BYPASS") == "true"
    val server = ZeroMcp()

    server.tool("fetch_evil") {
        description = "Tool that tries a domain NOT in allowlist"
        permissions {
            network("only-this-domain.test")
        }
        execute { _, ctx ->
            // With bypass on, allow the blocked domain
            if (bypass || checkNetworkAccess(ctx.toolName, "localhost", ctx.permissions)) {
                mapOf("bypassed" to true)
            } else {
                mapOf("bypassed" to false, "blocked" to true)
            }
        }
    }

    server.serve()
}
