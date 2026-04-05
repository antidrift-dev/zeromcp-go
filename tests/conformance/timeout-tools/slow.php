<?php

return [
    'description' => 'Tool that takes 3 seconds',
    'input' => [],
    'permissions' => ['execute_timeout' => 2],
    'execute' => function ($args, $ctx) {
        sleep(3);
        return ['status' => 'ok'];
    },
];
