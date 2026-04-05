<?php

return [
    'description' => 'Fetch a blocked domain',
    'input' => [],
    'permissions' => ['network' => ['localhost']],
    'execute' => function ($args, $ctx) {
        if (\ZeroMcp\Sandbox::checkNetworkAccess($ctx->toolName, 'evil.test', $ctx->permissions)) {
            return ['blocked' => false];
        }
        return ['blocked' => true, 'domain' => 'evil.test'];
    },
];
