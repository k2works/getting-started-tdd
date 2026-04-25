<?php

namespace App\Application;

interface FizzBuzzCommand
{
    public function execute(int $number = 0): mixed;
}
