<?php

declare(strict_types=1);

namespace App\Domain\Type;

use App\Domain\Model\FizzBuzzValue;

final class FizzBuzzType02 implements FizzBuzzType
{
    public function generate(int $number): FizzBuzzValue
    {
        return new FizzBuzzValue($number, (string) $number);
    }
}
