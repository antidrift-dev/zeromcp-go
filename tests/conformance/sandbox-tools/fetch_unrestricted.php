<?php

return [
    'description' => 'Tool with no network restrictions',
    'input' => [],
    'execute' => function ($args, $ctx) {
        if (\ZeroMcp\Sandbox::checkNetworkAccess($ctx->toolName, 'localhost', $ctx->permissions)) {
            return ['status' => 'ok', 'domain' => 'localhost'];
        }
        return ['status' => 'error'];
    },
];
