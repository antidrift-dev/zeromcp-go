import ZeroMcp
import Foundation

let bypass = ProcessInfo.processInfo.environment["ZEROMCP_BYPASS"] == "true"
let server = ZeroMcp()

server.tool(
    "fetch_evil",
    description: "Tool that tries a domain NOT in allowlist",
    input: [:],
    permissions: Permissions(network: .allowlist(["only-this-domain.test"]))
) { args, ctx in
    // With bypass on, allow the blocked domain
    if bypass || checkNetworkAccess(toolName: ctx.toolName, hostname: "localhost", permissions: ctx.permissions) {
        return ["bypassed": true] as [String: Any]
    }
    return ["bypassed": false, "blocked": true] as [String: Any]
}

await server.serve()
