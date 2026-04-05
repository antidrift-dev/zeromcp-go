<?php

return [
    'description' => 'Check if credentials were injected',
    'input' => [],
    'execute' => function ($args, $ctx) {
        return [
            'has_credentials' => $ctx->credentials !== null,
            'value' => $ctx->credentials,
        ];
    },
];
