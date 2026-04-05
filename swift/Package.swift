// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "ZeroMcp",
    platforms: [.macOS(.v13)],
    products: [
        .library(name: "ZeroMcp", targets: ["ZeroMcp"]),
        .executable(name: "zeromcp-example", targets: ["Example"]),
        .executable(name: "zeromcp-sandbox-test", targets: ["SandboxTest"]),
        .executable(name: "zeromcp-chaos-test", targets: ["ChaosTest"]),
    ],
    targets: [
        .target(
            name: "ZeroMcp",
            path: "Sources/ZeroMcp"
        ),
        .executableTarget(
            name: "Example",
            dependencies: ["ZeroMcp"],
            path: "Sources/Example"
        ),
        .executableTarget(
            name: "SandboxTest",
            dependencies: ["ZeroMcp"],
            path: "Sources/SandboxTest"
        ),
        .executableTarget(
            name: "ChaosTest",
            dependencies: ["ZeroMcp"],
            path: "Sources/ChaosTest"
        ),
        .testTarget(
            name: "ZeroMcpTests",
            dependencies: ["ZeroMcp"],
            path: "Tests/ZeroMcpTests"
        ),
    ]
)
