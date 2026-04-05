namespace ZeroMcp;

public static class Sandbox
{
    public static bool CheckNetworkAccess(
        string toolName,
        string hostname,
        Permissions? permissions,
        bool bypass = false,
        bool logging = false)
    {
        if (permissions == null || permissions.Network == null)
        {
            if (logging) Log($"{toolName} -> {hostname}");
            return true;
        }

        // Network = true means full access
        if (permissions.Network is bool b)
        {
            if (b)
            {
                if (logging) Log($"{toolName} -> {hostname}");
                return true;
            }
            // Network = false means denied
            if (bypass)
            {
                if (logging) Log($"! {toolName} -> {hostname} (network disabled -- bypassed)");
                return true;
            }
            if (logging) Log($"{toolName} x {hostname} (network disabled)");
            return false;
        }

        // Network = string[] means allowlist
        if (permissions.Network is string[] allowlist)
        {
            if (allowlist.Length == 0)
            {
                if (bypass)
                {
                    if (logging) Log($"! {toolName} -> {hostname} (network disabled -- bypassed)");
                    return true;
                }
                if (logging) Log($"{toolName} x {hostname} (network disabled)");
                return false;
            }

            if (IsAllowed(hostname, allowlist))
            {
                if (logging) Log($"{toolName} -> {hostname}");
                return true;
            }

            if (bypass)
            {
                if (logging) Log($"! {toolName} -> {hostname} (not in allowlist -- bypassed)");
                return true;
            }
            if (logging) Log($"{toolName} x {hostname} (not in allowlist)");
            return false;
        }

        // Unknown type — allow by default
        if (logging) Log($"{toolName} -> {hostname}");
        return true;
    }

    public static bool IsAllowed(string hostname, string[] allowlist)
    {
        foreach (var pattern in allowlist)
        {
            if (pattern.StartsWith("*."))
            {
                var suffix = pattern[1..]; // e.g. ".example.com"
                var baseDomain = pattern[2..]; // e.g. "example.com"
                if (hostname.EndsWith(suffix) || hostname == baseDomain)
                    return true;
            }
            else if (hostname == pattern)
            {
                return true;
            }
        }
        return false;
    }

    public static string ExtractHostname(string url)
    {
        var schemeEnd = url.IndexOf("://");
        var afterScheme = schemeEnd >= 0 ? url[(schemeEnd + 3)..] : url;
        var pathStart = afterScheme.IndexOf('/');
        var hostPort = pathStart >= 0 ? afterScheme[..pathStart] : afterScheme;
        var colonPos = hostPort.IndexOf(':');
        return colonPos >= 0 ? hostPort[..colonPos] : hostPort;
    }

    private static void Log(string msg)
    {
        Console.Error.WriteLine($"[zeromcp] {msg}");
    }
}
