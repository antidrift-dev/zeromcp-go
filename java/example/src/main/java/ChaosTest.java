import io.antidrift.zeromcp.*;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;

public class ChaosTest {
    static final List<byte[]> leaks = new ArrayList<>();

    public static void main(String[] args) {
        var server = new ZeroMcp();

        server.tool("hello", Tool.builder()
            .description("Say hello")
            .input(Input.required("name", "string"))
            .execute((a, ctx) -> "Hello, " + a.get("name") + "!")
            .build());

        server.tool("throw_error", Tool.builder()
            .description("Tool that throws")
            .execute((a, ctx) -> { throw new RuntimeException("Intentional chaos"); })
            .build());

        server.tool("hang", Tool.builder()
            .description("Tool that hangs forever")
            .execute((a, ctx) -> { Thread.sleep(Long.MAX_VALUE); return null; })
            .build());

        server.tool("slow", Tool.builder()
            .description("Tool that takes 3 seconds")
            .execute((a, ctx) -> { Thread.sleep(3000); return Map.of("status", "ok", "delay_ms", 3000); })
            .build());

        server.tool("leak_memory", Tool.builder()
            .description("Tool that leaks memory")
            .execute((a, ctx) -> {
                leaks.add(new byte[1024 * 1024]);
                return Map.of("leaked_buffers", leaks.size(), "total_mb", leaks.size());
            })
            .build());

        server.tool("stdout_corrupt", Tool.builder()
            .description("Tool that writes to stdout")
            .execute((a, ctx) -> { System.out.println("CORRUPTED OUTPUT"); return Map.of("status", "ok"); })
            .build());

        server.serve();
    }
}
