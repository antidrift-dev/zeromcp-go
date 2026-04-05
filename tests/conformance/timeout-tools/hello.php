<?php

return [
    'description' => 'Fast tool',
    'input' => ['name' => 'string'],
    'execute' => function ($args, $ctx) {
        return 'Hello, ' . ($args['name'] ?? 'world') . '!';
    },
];
