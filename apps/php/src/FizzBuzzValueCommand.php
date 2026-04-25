<?php

namespace App;

final class FizzBuzzValueCommand implements FizzBuzzCommand
{
    public function __construct(
        private readonly FizzBuzzType $type,
    ) {
    }

    public function execute(int $number = 0): FizzBuzzValue
    {
        return $this->type->generate($number);
    }
}
