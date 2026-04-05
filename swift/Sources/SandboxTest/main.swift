import ZeroMcp

let server = ZeroMcp()

server.tool(
    "fetch_allowed",
    description: "Fetch an allowed domain",
    input: [:],
    permissions: Permissions(network: .allowlist(["localhost"]))
) { args, ctx in
    if checkNetworkAccess(toolName: ctx.toolName, hostname: "localhost", permissions: ctx.permissions) {
        return ["status": "ok", "domain": "localhost"] as [String: Any]
    }
    return ["status": "error"] as [String: Any]
}

server.tool(
    "fetch_blocked",
    description: "Fetch a blocked domain",
    input: [:],
    permissions: Permissions(network: .allowlist(["localhost"]))
) { args, ctx in
    if checkNetworkAccess(toolName: ctx.toolName, hostname: "evil.test", permissions: ctx.permissions) {
        return ["blocked": false] as [String: Any]
    }
    return ["blocked": true, "domain": "evil.test"] as [String: Any]
}

server.tool(
    "fetch_no_network",
    description: "Tool with network disabled",
    input: [:],
    permissions: Permissions(network: .none)
) { args, ctx in
    if checkNetworkAccess(toolName: ctx.toolName, hostname: "localhost", permissions: ctx.permissions) {
        return ["blocked": false] as [String: Any]
    }
    return ["blocked": true] as [String: Any]
}

server.tool(
    "fetch_unrestricted",
    description: "Tool with no network restrictions",
    input: [:]
) { args, ctx in
    if checkNetworkAccess(toolName: ctx.toolName, hostname: "localhost", permissions: ctx.permissions) {
        return ["status": "ok", "domain": "localhost"] as [String: Any]
    }
    return ["status": "error"] as [String: Any]
}

server.tool(
    "fetch_wildcard",
    description: "Tool with wildcard network permission",
    input: [:],
    permissions: Permissions(network: .allowlist(["*.localhost"]))
) { args, ctx in
    if checkNetworkAccess(toolName: ctx.toolName, hostname: "localhost", permissions: ctx.permissions) {
        return ["status": "ok", "domain": "localhost"] as [String: Any]
    }
    return ["status": "error"] as [String: Any]
}

await server.serve()
