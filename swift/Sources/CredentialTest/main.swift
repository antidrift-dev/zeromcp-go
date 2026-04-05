import ZeroMcp
import Foundation

let server = ZeroMcp()

// Resolve CRM credentials from TEST_CRM_KEY env var
let crmKey = ProcessInfo.processInfo.environment["TEST_CRM_KEY"]

server.tool(
    "crm_check_creds",
    description: "Check if credentials were injected",
    input: [:]
) { args, ctx in
    return [
        "has_credentials": crmKey != nil,
        "value": crmKey as Any,
    ] as [String: Any]
}

server.tool(
    "nocreds_check_creds",
    description: "Check credentials in unconfigured namespace",
    input: [:]
) { args, ctx in
    return [
        "has_credentials": false,
        "value": NSNull(),
    ] as [String: Any]
}

await server.serve()
