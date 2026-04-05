import ZeroMcp
import Foundation

var leaks: [Data] = []

let server = ZeroMcp()

server.tool("hello", description: "Say hello", input: ["name": .simple(.string)]) { args, ctx in
    "Hello, \(args["name"] as? String ?? "world")!"
}

server.tool("throw_error", description: "Tool that throws", input: [:]) { _, _ in
    throw NSError(domain: "chaos", code: 1, userInfo: [NSLocalizedDescriptionKey: "Intentional chaos"])
}

server.tool("hang", description: "Tool that hangs forever", input: [:]) { _, _ in
    try await Task.sleep(for: .seconds(86400))
    return "unreachable"
}

server.tool("slow", description: "Tool that takes 3 seconds", input: [:]) { _, _ in
    try await Task.sleep(for: .seconds(3))
    return ["status": "ok", "delay_ms": 3000] as [String: Any]
}

server.tool("leak_memory", description: "Tool that leaks memory", input: [:]) { _, _ in
    leaks.append(Data(count: 1024 * 1024))
    return ["leaked_buffers": leaks.count, "total_mb": leaks.count] as [String: Any]
}

server.tool("stdout_corrupt", description: "Tool that writes to stdout", input: [:]) { _, _ in
    print("CORRUPTED OUTPUT")
    return ["status": "ok"] as [String: Any]
}

await server.serve()
