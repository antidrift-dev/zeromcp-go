<?php

namespace ZeroMcp;

class Config
{
    public string $toolsDir;
    public string $separator;
    public bool $logging;
    public bool $bypassPermissions;
    public int $executeTimeout; // seconds

    public function __construct(array $opts = [])
    {
        $this->toolsDir = $opts['tools'] ?? './tools';
        $this->separator = $opts['separator'] ?? '_';
        $this->logging = $opts['logging'] ?? false;
        $this->bypassPermissions = $opts['bypass_permissions'] ?? false;
        $this->executeTimeout = $opts['execute_timeout'] ?? 30;
    }

    public static function load(?string $path = null): self
    {
        $path = $path ?? getcwd() . '/zeromcp.config.json';
        if (!file_exists($path)) {
            return new self();
        }

        $raw = file_get_contents($path);
        $data = json_decode($raw, true);
        if (!is_array($data)) {
            return new self();
        }

        return new self($data);
    }
}
