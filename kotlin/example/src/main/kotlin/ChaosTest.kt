import io.antidrift.zeromcp.*

val leaksKt = mutableListOf<ByteArray>()

fun chaosTestMain() {
    val server = ZeroMcp()

    server.tool("hello") {
        description = "Say hello"
        input { "name" to "string" }
        execute { args, _ -> "Hello, ${args.getString("name")}!" }
    }

    server.tool("throw_error") {
        description = "Tool that throws"
        execute { _, _ -> throw RuntimeException("Intentional chaos") }
    }

    server.tool("hang") {
        description = "Tool that hangs forever"
        execute { _, _ -> Thread.sleep(Long.MAX_VALUE); null }
    }

    server.tool("slow") {
        description = "Tool that takes 3 seconds"
        execute { _, _ -> Thread.sleep(3000); mapOf("status" to "ok", "delay_ms" to 3000) }
    }

    server.tool("leak_memory") {
        description = "Tool that leaks memory"
        execute { _, _ ->
            leaksKt.add(ByteArray(1024 * 1024))
            mapOf("leaked_buffers" to leaksKt.size, "total_mb" to leaksKt.size)
        }
    }

    server.tool("stdout_corrupt") {
        description = "Tool that writes to stdout"
        execute { _, _ -> println("CORRUPTED OUTPUT"); mapOf("status" to "ok") }
    }

    server.serve()
}
