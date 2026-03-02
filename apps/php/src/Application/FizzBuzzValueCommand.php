<?php

declare(strict_types=1);

namespace App\Application;

use App\Domain\Model\FizzBuzzValue;
use App\Domain\Type\FizzBuzzType;

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
