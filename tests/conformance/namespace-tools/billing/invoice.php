<?php

return [
    'description' => 'Create an invoice',
    'input' => [],
    'execute' => function ($args, $ctx) {
        return ['tool' => 'billing_invoice'];
    },
];
