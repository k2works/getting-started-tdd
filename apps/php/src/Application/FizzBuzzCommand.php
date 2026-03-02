<?php

declare(strict_types=1);

namespace App\Application;

interface FizzBuzzCommand
{
    public function execute(int $number = 0): mixed;
}
