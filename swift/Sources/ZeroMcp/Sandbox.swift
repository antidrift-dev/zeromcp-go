import Foundation

public struct SandboxOptions {
    public var logging: Bool
    public var bypass: Bool

    public init(logging: Bool = false, bypass: Bool = false) {
        self.logging = logging
        self.bypass = bypass
    }
}

public func checkNetworkAccess(
    toolName: String,
    hostname: String,
    permissions: Permissions,
    options: SandboxOptions = SandboxOptions()
) -> Bool {
    switch permissions.network {
    case .full:
        if options.logging {
            log("\(toolName) -> \(hostname)")
        }
        return true

    case .none:
        if options.bypass {
            if options.logging {
                log("! \(toolName) -> \(hostname) (network disabled -- bypassed)")
            }
            return true
        }
        if options.logging {
            log("\(toolName) x \(hostname) (network disabled)")
        }
        return false

    case .allowlist(let hosts):
        if isAllowed(hostname: hostname, allowlist: hosts) {
            if options.logging {
                log("\(toolName) -> \(hostname)")
            }
            return true
        }
        if options.bypass {
            if options.logging {
                log("! \(toolName) -> \(hostname) (not in allowlist -- bypassed)")
            }
            return true
        }
        if options.logging {
            log("\(toolName) x \(hostname) (not in allowlist)")
        }
        return false
    }
}

public func isAllowed(hostname: String, allowlist: [String]) -> Bool {
    for pattern in allowlist {
        if pattern.hasPrefix("*.") {
            let suffix = String(pattern.dropFirst(1)) // e.g. ".example.com"
            let base = String(pattern.dropFirst(2))   // e.g. "example.com"
            if hostname.hasSuffix(suffix) || hostname == base {
                return true
            }
        } else if hostname == pattern {
            return true
        }
    }
    return false
}

public func extractHostname(from url: String) -> String {
    guard let range = url.range(of: "://") else { return url }
    let afterScheme = url[range.upperBound...]
    let hostPort = afterScheme.split(separator: "/").first.map(String.init) ?? String(afterScheme)
    return hostPort.split(separator: ":").first.map(String.init) ?? hostPort
}

private func log(_ msg: String) {
    fputs("[zeromcp] \(msg)\n", stderr)
}
