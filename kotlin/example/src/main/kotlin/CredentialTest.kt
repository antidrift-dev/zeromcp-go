import io.antidrift.zeromcp.*

fun credentialTestMain() {
    val server = ZeroMcp()

    // Resolve CRM credentials from TEST_CRM_KEY env var
    val crmKey: String? = System.getenv("TEST_CRM_KEY")

    server.tool("crm_check_creds") {
        description = "Check if credentials were injected"
        execute { _, _ ->
            mapOf(
                "has_credentials" to (crmKey != null),
                "value" to crmKey
            )
        }
    }

    server.tool("nocreds_check_creds") {
        description = "Check credentials in unconfigured namespace"
        execute { _, _ ->
            mapOf(
                "has_credentials" to false,
                "value" to null
            )
        }
    }

    server.serve()
}
