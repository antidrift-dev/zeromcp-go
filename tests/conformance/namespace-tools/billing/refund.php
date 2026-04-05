<?php

return [
    'description' => 'Process a refund',
    'input' => [],
    'execute' => function ($args, $ctx) {
        return ['tool' => 'billing_refund'];
    },
];
