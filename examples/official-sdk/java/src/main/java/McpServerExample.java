import java.util.List;
import java.util.Map;

import io.modelcontextprotocol.json.McpJsonDefaults;
import io.modelcontextprotocol.server.McpServer;
import io.modelcontextprotocol.server.McpSyncServer;
import io.modelcontextprotocol.server.transport.StdioServerTransportProvider;
import io.modelcontextprotocol.spec.McpSchema;
import io.modelcontextprotocol.spec.McpSchema.CallToolResult;
import io.modelcontextprotocol.spec.McpSchema.ServerCapabilities;
import io.modelcontextprotocol.spec.McpSchema.TextContent;
import io.modelcontextprotocol.spec.McpSchema.Tool;

public class McpServerExample {

    public static void main(String[] args) {
        // 1. Create the stdio transport provider (reads stdin, writes stdout)
        var transport = new StdioServerTransportProvider(McpJsonDefaults.getMapper());

        // 2. Define the "hello" tool
        Tool helloTool = Tool.builder()
            .name("hello")
            .description("Say hello to someone")
            .inputSchema(new McpSchema.JsonSchema(
                "object",
                Map.of("name", Map.of("type", "string", "description", "The person's name")),
                List.of("name"),
                null, null, null
            ))
            .build();

        // 3. Define the "add" tool
        Tool addTool = Tool.builder()
            .name("add")
            .description("Add two numbers together")
            .inputSchema(new McpSchema.JsonSchema(
                "object",
                Map.of(
                    "a", Map.of("type", "number", "description", "First number"),
                    "b", Map.of("type", "number", "description", "Second number")
                ),
                List.of("a", "b"),
                null, null, null
            ))
            .build();

        // 4. Build the synchronous server with both tools
        McpSyncServer server = McpServer.sync(transport)
            .serverInfo("example-server", "1.0.0")
            .capabilities(ServerCapabilities.builder().tools(true).build())
            .toolCall(helloTool, (exchange, request) -> {
                String name = (String) request.arguments().get("name");
                return CallToolResult.builder()
                    .content(List.of(new TextContent("Hello, " + name + "!")))
                    .build();
            })
            .toolCall(addTool, (exchange, request) -> {
                double a = ((Number) request.arguments().get("a")).doubleValue();
                double b = ((Number) request.arguments().get("b")).doubleValue();
                String json = "{\"sum\":" + (a + b) + "}";
                return CallToolResult.builder()
                    .content(List.of(new TextContent(json)))
                    .build();
            })
            .build();

        // Server is now running and processing stdio messages.
        // It will block until the transport is closed (e.g. stdin EOF).
    }
}
