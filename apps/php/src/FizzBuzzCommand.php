<?php

namespace App;

interface FizzBuzzCommand
{
    public function execute(int $number = 0): mixed;
}
