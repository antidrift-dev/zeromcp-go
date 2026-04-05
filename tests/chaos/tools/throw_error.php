<?php
return [
    'description' => 'Tool that throws',
    'input' => [],
    'execute' => function ($args, $ctx) {
        throw new \RuntimeException("Intentional chaos: unhandled exception");
    },
];
