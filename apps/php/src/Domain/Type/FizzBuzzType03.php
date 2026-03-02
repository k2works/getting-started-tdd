<?php

declare(strict_types=1);

namespace App\Domain\Type;

use App\Domain\Model\FizzBuzzValue;

final class FizzBuzzType03 implements FizzBuzzType
{
    public function generate(int $number): FizzBuzzValue
    {
        if ($number % 3 === 0 && $number % 5 === 0) {
            return new FizzBuzzValue($number, 'FizzBuzz');
        }

        return new FizzBuzzValue($number, (string) $number);
    }
}
