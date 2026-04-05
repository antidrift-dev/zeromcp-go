import MCP
import Foundation

// Create a server with tools capability
let server = Server(
    name: "example-server",
    version: "1.0.0",
    capabilities: .init(
        tools: .init(listChanged: false)
    )
)

// Register tool list handler (before starting)
await server.withMethodHandler(ListTools.self) { _ in
    let tools = [
        Tool(
            name: "hello",
            description: "Say hello to someone",
            inputSchema: .object([
                "type": .string("object"),
                "properties": .object([
                    "name": .object([
                        "type": .string("string"),
                        "description": .string("The person's name"),
                    ]),
                ]),
                "required": .array([.string("name")]),
            ])
        ),
        Tool(
            name: "add",
            description: "Add two numbers together",
            inputSchema: .object([
                "type": .string("object"),
                "properties": .object([
                    "a": .object([
                        "type": .string("number"),
                        "description": .string("First number"),
                    ]),
                    "b": .object([
                        "type": .string("number"),
                        "description": .string("Second number"),
                    ]),
                ]),
                "required": .array([.string("a"), .string("b")]),
            ])
        ),
    ]
    return .init(tools: tools)
}

// Register tool call handler
await server.withMethodHandler(CallTool.self) { params in
    switch params.name {
    case "hello":
        let name = params.arguments?["name"]?.stringValue ?? "world"
        return .init(content: [.text(text: "Hello, \(name)!", annotations: nil, _meta: nil)])

    case "add":
        let a = params.arguments?["a"]?.doubleValue ?? 0
        let b = params.arguments?["b"]?.doubleValue ?? 0
        return .init(content: [.text(text: "{\"sum\":\(a + b)}", annotations: nil, _meta: nil)])

    default:
        return .init(content: [.text(text: "Unknown tool: \(params.name)", annotations: nil, _meta: nil)], isError: true)
    }
}

// Create the stdio transport and start the server
let transport = StdioTransport()
try await server.start(transport: transport)

// Keep the process alive to handle stdio messages.
// The server's internal task processes messages from stdin;
// we use a never-completing async sleep so the process doesn't exit.
while true {
    try await Task.sleep(for: .seconds(3600))
}
