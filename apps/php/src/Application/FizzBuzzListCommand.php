<?php

namespace App\Application;

use App\Domain\Model\FizzBuzzList;
use App\Domain\Type\FizzBuzzType;

final class FizzBuzzListCommand implements FizzBuzzCommand
{
    private const MAX_NUMBER = 100;

    public function __construct(
        private readonly FizzBuzzType $type,
        private readonly int $maxNumber = self::MAX_NUMBER,
    ) {
        if ($maxNumber > self::MAX_NUMBER) {
            throw new \InvalidArgumentException(
                sprintf('最大値は%d以下である必要があります', self::MAX_NUMBER)
            );
        }
    }

    public function execute(int $number = 0): FizzBuzzList
    {
        $maxNumber = $number === 0 ? $this->maxNumber : $number;
        $values = [];

        for ($i = 1; $i <= $maxNumber; $i++) {
            $values[] = $this->type->generate($i);
        }

        return new FizzBuzzList($values);
    }
}
