<?php
return [
    'description' => 'Tool that takes 3 seconds',
    'input' => [],
    'execute' => function ($args, $ctx) {
        sleep(3);
        return ['status' => 'ok', 'delay_ms' => 3000];
    },
];
