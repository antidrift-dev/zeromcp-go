#!/usr/bin/env php
<?php

declare(strict_types=1);

require_once __DIR__ . '/vendor/autoload.php';

use Mcp\Server;
use Mcp\Server\Transport\StdioTransport;

// Build the server with two tools registered manually via closures.
// The SDK infers parameter names, types, and JSON schema from the
// closure signatures automatically.
$server = Server::builder()
    ->setServerInfo('example-server', '1.0.0')
    ->addTool(
        handler: function (string $name): string {
            return "Hello, {$name}!";
        },
        name: 'hello',
        description: 'Say hello to someone',
    )
    ->addTool(
        handler: function (float $a, float $b): array {
            return ['sum' => $a + $b];
        },
        name: 'add',
        description: 'Add two numbers together',
    )
    ->build();

// Run on stdio transport
$transport = new StdioTransport();
$server->run($transport);
