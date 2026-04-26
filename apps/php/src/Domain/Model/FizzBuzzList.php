<?php

namespace App\Domain\Model;

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

    /**
     * @param callable(FizzBuzzValue): bool $predicate
     */
    public function filter(callable $predicate): self
    {
        return new self(
            array_values(array_filter($this->value, $predicate))
        );
    }

    /**
     * @template R
     * @param callable(FizzBuzzValue): R $callback
     * @return R[]
     */
    public function map(callable $callback): array
    {
        return array_map($callback, $this->value);
    }

    /**
     * @return array<string, FizzBuzzValue[]>
     */
    public function groupByValue(): array
    {
        $result = [];
        foreach ($this->value as $value) {
            $result[$value->getValue()][] = $value;
        }

        return $result;
    }

    /**
     * @return array<string, int>
     */
    public function countByValue(): array
    {
        $result = [];
        foreach ($this->value as $value) {
            $key = $value->getValue();
            $result[$key] = ($result[$key] ?? 0) + 1;
        }

        return $result;
    }

    public function take(int $number): self
    {
        return new self(array_slice($this->value, 0, $number));
    }

    public function join(string $separator): string
    {
        return implode($separator, $this->toStringArray());
    }

    /**
     * @template R
     * @param R $initial
     * @param callable(R, FizzBuzzValue): R $callback
     * @return R
     */
    public function reduce(mixed $initial, callable $callback): mixed
    {
        return array_reduce($this->value, $callback, $initial);
    }

    public function __toString(): string
    {
        return implode(',', $this->toStringArray());
    }
}
