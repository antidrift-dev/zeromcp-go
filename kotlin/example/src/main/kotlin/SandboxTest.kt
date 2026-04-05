import io.antidrift.zeromcp.*

fun sandboxTestMain() {
    val server = ZeroMcp()

    server.tool("fetch_allowed") {
        description = "Fetch an allowed domain"
        permissions {
            network("localhost")
        }
        execute { args, ctx ->
            if (checkNetworkAccess(ctx.toolName, "localhost", ctx.permissions)) {
                mapOf("status" to "ok", "domain" to "localhost")
            } else {
                mapOf("status" to "error")
            }
        }
    }

    server.tool("fetch_blocked") {
        description = "Fetch a blocked domain"
        permissions {
            network("localhost")
        }
        execute { args, ctx ->
            if (checkNetworkAccess(ctx.toolName, "evil.test", ctx.permissions)) {
                mapOf("blocked" to false)
            } else {
                mapOf("blocked" to true, "domain" to "evil.test")
            }
        }
    }

    server.tool("fetch_no_network") {
        description = "Tool with network disabled"
        permissions {
            networkDeny()
        }
        execute { args, ctx ->
            if (checkNetworkAccess(ctx.toolName, "localhost", ctx.permissions)) {
                mapOf("blocked" to false)
            } else {
                mapOf("blocked" to true)
            }
        }
    }

    server.tool("fetch_unrestricted") {
        description = "Tool with no network restrictions"
        execute { args, ctx ->
            if (checkNetworkAccess(ctx.toolName, "localhost", ctx.permissions)) {
                mapOf("status" to "ok", "domain" to "localhost")
            } else {
                mapOf("status" to "error")
            }
        }
    }

    server.tool("fetch_wildcard") {
        description = "Tool with wildcard network permission"
        permissions {
            network("*.localhost")
        }
        execute { args, ctx ->
            if (checkNetworkAccess(ctx.toolName, "localhost", ctx.permissions)) {
                mapOf("status" to "ok", "domain" to "localhost")
            } else {
                mapOf("status" to "error")
            }
        }
    }

    server.serve()
}
