# ZeroMCP &mdash; Kotlin

Sandboxed MCP server library for Kotlin. DSL registration, call `server.serve()`, done.

## Getting started

```kotlin
import io.antidrift.zeromcp.*

fun main() {
    val server = ZeroMcp()

    server.tool("hello") {
        description = "Say hello to someone"
        input {
            "name" to "string"
        }
        execute { args, _ ->
            "Hello, ${args.getString("name")}!"
        }
    }

    server.serve()
}
```

Stdio works immediately. No transport configuration needed.

## vs. the official SDK

The official Kotlin SDK (backed by JetBrains) requires server setup, transport configuration, and schema definition. ZeroMCP handles the protocol, transport, and schema generation with a clean Kotlin DSL and coroutine support.

The official SDK has **no sandbox**. ZeroMCP adds per-tool network allowlists, filesystem controls, and exec prevention.

## Requirements

- Kotlin 2.0+
- JVM 21
- Gradle

## Build & run

```sh
gradle :example:installDist -x test
./example/build/install/example/bin/example
```

## Sandbox

### Network allowlists

```kotlin
server.tool("fetch_url") {
    description = "Fetch a URL"
    input {
        required("url", "string", "The URL to fetch")
    }
    permissions {
        network("api.example.com", "*.github.com")
    }
    execute { args, ctx ->
        val url = args.getString("url") ?: return@execute "No URL provided"
        val host = java.net.URI(url).host
        if (!checkNetworkAccess(ctx.toolName, host, ctx.permissions)) {
            return@execute "Network access denied for $host"
        }
        "Fetched: $url"
    }
}
```

### Permission DSL

```kotlin
permissions {
    network("api.example.com", "*.internal.dev")
    fs(FsPermission.READ)
    exec(false)
}
```

## Testing

```sh
gradle test
```
