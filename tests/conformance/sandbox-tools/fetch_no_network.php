<?php

return [
    'description' => 'Tool with network disabled',
    'input' => [],
    'permissions' => ['network' => false],
    'execute' => function ($args, $ctx) {
        if (\ZeroMcp\Sandbox::checkNetworkAccess($ctx->toolName, 'localhost', $ctx->permissions)) {
            return ['blocked' => false];
        }
        return ['blocked' => true];
    },
];
