import io.antidrift.zeromcp.*

fun timeoutTestMain() {
    val server = ZeroMcp()

    server.tool("hello") {
        description = "Fast tool"
        input { "name" to "string" }
        execute { args, _ ->
            "Hello, ${args.getString("name")}!"
        }
    }

    server.tool("slow") {
        description = "Tool that takes 3 seconds"
        permissions {
            executeTimeout(2000)
        }
        execute { _, _ ->
            Thread.sleep(3000)
            mapOf("status" to "ok")
        }
    }

    server.serve()
}
