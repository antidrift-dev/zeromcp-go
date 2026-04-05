import io.antidrift.zeromcp.*;

import java.util.HashMap;
import java.util.Map;

public class CredentialTest {
    public static void main(String[] args) {
        var server = new ZeroMcp();

        // Resolve CRM credentials from TEST_CRM_KEY env var
        var crmKey = System.getenv("TEST_CRM_KEY");

        server.tool("crm_check_creds", Tool.builder()
            .description("Check if credentials were injected")
            .execute((a, ctx) -> {
                var result = new HashMap<String, Object>();
                result.put("has_credentials", crmKey != null);
                result.put("value", crmKey);
                return result;
            })
            .build());

        server.tool("nocreds_check_creds", Tool.builder()
            .description("Check credentials in unconfigured namespace")
            .execute((a, ctx) -> {
                var result = new HashMap<String, Object>();
                result.put("has_credentials", false);
                result.put("value", null);
                return result;
            })
            .build());

        server.serve();
    }
}
