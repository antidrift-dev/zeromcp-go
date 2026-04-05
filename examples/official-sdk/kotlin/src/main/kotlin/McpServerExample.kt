import io.ktor.utils.io.streams.asInput
import io.modelcontextprotocol.kotlin.sdk.server.Server
import io.modelcontextprotocol.kotlin.sdk.server.ServerOptions
import io.modelcontextprotocol.kotlin.sdk.server.StdioServerTransport
import io.modelcontextprotocol.kotlin.sdk.types.CallToolResult
import io.modelcontextprotocol.kotlin.sdk.types.Implementation
import io.modelcontextprotocol.kotlin.sdk.types.ServerCapabilities
import io.modelcontextprotocol.kotlin.sdk.types.TextContent
import io.modelcontextprotocol.kotlin.sdk.types.ToolSchema
import kotlinx.coroutines.Job
import kotlinx.coroutines.runBlocking
import kotlinx.io.asSink
import kotlinx.io.buffered
import kotlinx.serialization.json.buildJsonObject
import kotlinx.serialization.json.doubleOrNull
import kotlinx.serialization.json.jsonPrimitive
import kotlinx.serialization.json.put
import kotlinx.serialization.json.putJsonObject

fun main() {
    val server = Server(
        Implementation(name = "example-server", version = "1.0.0"),
        ServerOptions(
            capabilities = ServerCapabilities(
                tools = ServerCapabilities.Tools(listChanged = true),
            ),
        ),
    )

    // Register "hello" tool
    server.addTool(
        name = "hello",
        description = "Say hello to someone",
        inputSchema = ToolSchema(
            properties = buildJsonObject {
                putJsonObject("name") {
                    put("type", "string")
                    put("description", "The person's name")
                }
            },
            required = listOf("name"),
        ),
    ) { request ->
        val name = request.arguments?.get("name")?.jsonPrimitive?.content ?: "world"
        CallToolResult(content = listOf(TextContent("Hello, $name!")))
    }

    // Register "add" tool
    server.addTool(
        name = "add",
        description = "Add two numbers together",
        inputSchema = ToolSchema(
            properties = buildJsonObject {
                putJsonObject("a") {
                    put("type", "number")
                    put("description", "First number")
                }
                putJsonObject("b") {
                    put("type", "number")
                    put("description", "Second number")
                }
            },
            required = listOf("a", "b"),
        ),
    ) { request ->
        val a = request.arguments?.get("a")?.jsonPrimitive?.doubleOrNull ?: 0.0
        val b = request.arguments?.get("b")?.jsonPrimitive?.doubleOrNull ?: 0.0
        CallToolResult(content = listOf(TextContent("""{"sum":${a + b}}""")))
    }

    // Create stdio transport and run
    val transport = StdioServerTransport(
        System.`in`.asInput(),
        System.out.asSink().buffered(),
    )

    runBlocking {
        val session = server.createSession(transport)
        val done = Job()
        session.onClose { done.complete() }
        done.join()
    }
}
