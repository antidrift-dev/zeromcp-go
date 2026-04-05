<?php

return [
    'description' => 'Check credentials in unconfigured namespace',
    'input' => [],
    'execute' => function ($args, $ctx) {
        return [
            'has_credentials' => $ctx->credentials !== null,
            'value' => $ctx->credentials,
        ];
    },
];
