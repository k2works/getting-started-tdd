<?php

namespace App;

final class FizzBuzzList
{
    private const MAX_COUNT = 100;

    /** @var FizzBuzzValue[] */
    private readonly array $value;

    /**
     * @param FizzBuzzValue[] $value
     */
    public function __construct(array $value)
    {
        if (count($value) > self::MAX_COUNT) {
            throw new \InvalidArgumentException(
                sprintf('上限は%d件までです', self::MAX_COUNT)
            );
        }

        $this->value = $value;
    }

    /**
     * @return FizzBuzzValue[]
     */
    public function getValue(): array
    {
        return $this->value;
    }

    public function count(): int
    {
        return count($this->value);
    }

    /**
     * @return string[]
     */
    public function toStringArray(): array
    {
        return array_map(
            fn (FizzBuzzValue $value): string => $value->getValue(),
            $this->value
        );
    }

    public function __toString(): string
    {
        return implode(',', $this->toStringArray());
    }
}
