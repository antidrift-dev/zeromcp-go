<?php

return [
    'description' => 'Tool with wildcard network permission',
    'input' => [],
    'permissions' => ['network' => ['*.localhost']],
    'execute' => function ($args, $ctx) {
        if (\ZeroMcp\Sandbox::checkNetworkAccess($ctx->toolName, 'localhost', $ctx->permissions)) {
            return ['status' => 'ok', 'domain' => 'localhost'];
        }
        return ['status' => 'error'];
    },
];
