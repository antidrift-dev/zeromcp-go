# frozen_string_literal: true

module ZeroMcp
  module Sandbox
    module_function

    def check_network_access(tool_name, hostname, permissions, bypass: false, logging: false)
      network = permissions.key?(:network) ? permissions[:network] : permissions['network']

      # No permissions or network not specified = full access
      if network.nil?
        log("#{tool_name} -> #{hostname}") if logging
        return true
      end

      # network: true = full access
      if network == true
        log("#{tool_name} -> #{hostname}") if logging
        return true
      end

      # network: false = denied
      if network == false
        if bypass
          log("! #{tool_name} -> #{hostname} (network disabled -- bypassed)") if logging
          return true
        end
        log("#{tool_name} x #{hostname} (network disabled)") if logging
        return false
      end

      # network: [] (empty array) = denied
      if network.is_a?(Array) && network.empty?
        if bypass
          log("! #{tool_name} -> #{hostname} (network disabled -- bypassed)") if logging
          return true
        end
        log("#{tool_name} x #{hostname} (network disabled)") if logging
        return false
      end

      # network: ["host1", "*.host2"] = allowlist
      if network.is_a?(Array)
        if allowed?(hostname, network)
          log("#{tool_name} -> #{hostname}") if logging
          return true
        end
        if bypass
          log("! #{tool_name} -> #{hostname} (not in allowlist -- bypassed)") if logging
          return true
        end
        log("#{tool_name} x #{hostname} (not in allowlist)") if logging
        return false
      end

      # Unknown type — allow by default
      true
    end

    def allowed?(hostname, allowlist)
      allowlist.any? do |pattern|
        if pattern.start_with?('*.')
          suffix = pattern[1..] # e.g. ".example.com"
          base = pattern[2..]   # e.g. "example.com"
          hostname.end_with?(suffix) || hostname == base
        else
          hostname == pattern
        end
      end
    end

    def extract_hostname(url)
      after_scheme = url.sub(%r{^[a-z]+://}, '')
      host_port = after_scheme.split('/').first || after_scheme
      host_port.split(':').first || host_port
    end

    def log(msg)
      $stderr.puts "[zeromcp] #{msg}"
    end
  end
end
