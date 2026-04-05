import io.antidrift.zeromcp.*;

public class TimeoutTest {
    public static void main(String[] args) {
        var server = new ZeroMcp();

        server.tool("hello", Tool.builder()
            .description("Fast tool")
            .input(Input.required("name", "string"))
            .execute((a, ctx) -> "Hello, " + a.get("name") + "!")
            .build());

        server.tool("slow", Tool.builder()
            .description("Tool that takes 3 seconds")
            .permissions(new Permissions(
                Permissions.NetworkPermission.unset(),
                Permissions.FsPermission.NONE,
                false,
                2000
            ))
            .execute((a, ctx) -> {
                Thread.sleep(3000);
                return java.util.Map.of("status", "ok");
            })
            .build());

        server.serve();
    }
}
