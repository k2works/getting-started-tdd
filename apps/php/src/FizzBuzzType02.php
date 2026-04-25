<?php

namespace App;

class FizzBuzzType02 implements FizzBuzzType
{
    public function generate(int $number): FizzBuzzValue
    {
        return new FizzBuzzValue($number, (string) $number);
    }
}
