<?php

namespace App;

final class FizzBuzzValue
{
    public function __construct(
        private readonly int $number,
        private readonly string $value,
    ) {
        if ($number < 0) {
            throw new \InvalidArgumentException('値は正の値のみ許可します');
        }
    }

    public function getNumber(): int
    {
        return $this->number;
    }

    public function getValue(): string
    {
        return $this->value;
    }

    public function equals(self $other): bool
    {
        return $this->number === $other->number
            && $this->value === $other->value;
    }

    public function __toString(): string
    {
        return $this->value;
    }
}
