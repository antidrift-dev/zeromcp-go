<?php
return [
    'description' => 'Say hello',
    'input' => ['name' => 'string'],
    'execute' => function ($args, $ctx) {
        return "Hello, {$args['name']}!";
    },
];
