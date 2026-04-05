// swift-tools-version: 6.0
import PackageDescription

let package = Package(
    name: "mcp-server-example",
    platforms: [.macOS(.v13)],
    dependencies: [
        .package(url: "https://github.com/modelcontextprotocol/swift-sdk.git", from: "0.12.0"),
    ],
    targets: [
        .executableTarget(
            name: "McpServerExample",
            dependencies: [
                .product(name: "MCP", package: "swift-sdk"),
            ],
            path: "Sources"
        ),
    ]
)
