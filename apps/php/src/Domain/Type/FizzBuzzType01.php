<?php

namespace App\Domain\Type;

use App\Domain\Model\FizzBuzzValue;

final class FizzBuzzType01 implements FizzBuzzType
{
    public function generate(int $number): FizzBuzzValue
    {
        if ($number % 15 === 0) {
            return new FizzBuzzValue($number, 'FizzBuzz');
        }

        if ($number % 3 === 0) {
            return new FizzBuzzValue($number, 'Fizz');
        }

        if ($number % 5 === 0) {
            return new FizzBuzzValue($number, 'Buzz');
        }

        return new FizzBuzzValue($number, (string) $number);
    }
}
