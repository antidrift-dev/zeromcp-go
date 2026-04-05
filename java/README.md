# ZeroMCP &mdash; Java

Sandboxed MCP server library for Java. Builder API, call `server.serve()`, done.

## Getting started

```java
import io.antidrift.zeromcp.*;

public class Main {
    public static void main(String[] args) {
        var server = new ZeroMcp();

        server.tool("hello", Tool.builder()
            .description("Say hello to someone")
            .input(Input.required("name", "string", "The person's name"))
            .execute((a, ctx) -> "Hello, " + a.get("name") + "!")
            .build());

        server.serve();
    }
}
```

Stdio works immediately. No transport configuration needed.

## vs. the official SDK

The official Java SDK (backed by Spring AI) requires server setup, transport configuration, and schema definition. ZeroMCP handles the protocol, transport, and schema generation with a clean builder API &mdash; no Spring framework required, just a JAR.

The official SDK has **no sandbox**. ZeroMCP adds per-tool network allowlists, filesystem controls, and exec prevention.

## Requirements

- Java 17+
- Maven

## Build & run

```sh
mvn package -q -DskipTests
mvn dependency:copy-dependencies -DoutputDirectory=target/deps -q
javac -cp "target/zeromcp-0.1.0.jar:target/deps/*" -d /tmp/java-out example/src/main/java/Main.java
java -cp "target/zeromcp-0.1.0.jar:target/deps/*:/tmp/java-out" Main
```

## Sandbox

### Network allowlists

```java
server.tool("fetch_url", Tool.builder()
    .description("Fetch a URL")
    .input(Input.required("url", "string"))
    .permissions(new Permissions(
        Permissions.NetworkPermission.allowList("api.example.com", "*.github.com"),
        Permissions.FsPermission.NONE,
        false  // exec
    ))
    .execute((a, ctx) -> {
        var url = (String) a.get("url");
        var host = java.net.URI.create(url).getHost();
        if (!Sandbox.checkNetworkAccess(ctx.toolName(), host, ctx.permissions())) {
            return "Network access denied for " + host;
        }
        return "Fetched: " + url;
    })
    .build());
```

### Permission model

Sealed interface pattern for type-safe permissions:

- `NetworkPermission.allowList(...)` / `.ALL` / `.DENIED`
- `FsPermission.READ` / `.WRITE` / `.NONE`
- `exec: true/false`

## Testing

```sh
mvn test
```
