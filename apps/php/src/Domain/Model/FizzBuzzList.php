<?php

declare(strict_types=1);

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
            throw new \InvalidArgumentException(sprintf('上限は%d件までです', self::MAX_COUNT));
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
        return array_map(fn (FizzBuzzValue $v): string => $v->getValue(), $this->value);
    }

    public function __toString(): string
    {
        return implode(',', $this->toStringArray());
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
     * @param callable(FizzBuzzValue): R $fn
     * @return R[]
     */
    public function map(callable $fn): array
    {
        return array_map($fn, $this->value);
    }

    /**
     * @return array<string, FizzBuzzValue[]>
     */
    public function groupByValue(): array
    {
        $result = [];
        foreach ($this->value as $v) {
            $result[$v->getValue()][] = $v;
        }

        return $result;
    }

    /**
     * @return array<string, int>
     */
    public function countByValue(): array
    {
        $result = [];
        foreach ($this->value as $v) {
            $key = $v->getValue();
            $result[$key] = ($result[$key] ?? 0) + 1;
        }

        return $result;
    }

    public function take(int $n): self
    {
        return new self(array_slice($this->value, 0, $n));
    }

    public function join(string $separator): string
    {
        return implode($separator, $this->toStringArray());
    }

    /**
     * @template R
     * @param R $initial
     * @param callable(R, FizzBuzzValue): R $fn
     * @return R
     */
    public function reduce(mixed $initial, callable $fn): mixed
    {
        return array_reduce($this->value, $fn, $initial);
    }

    /**
     * @param callable(FizzBuzzValue): bool $predicate
     */
    public function findFirst(callable $predicate): ?FizzBuzzValue
    {
        foreach ($this->value as $v) {
            if ($predicate($v)) {
                return $v;
            }
        }

        return null;
    }

    /**
     * @param callable(FizzBuzzValue): bool $predicate
     */
    public function anyMatch(callable $predicate): bool
    {
        foreach ($this->value as $v) {
            if ($predicate($v)) {
                return true;
            }
        }

        return false;
    }

    /**
     * @param callable(FizzBuzzValue): bool $predicate
     */
    public function allMatch(callable $predicate): bool
    {
        foreach ($this->value as $v) {
            if (! $predicate($v)) {
                return false;
            }
        }

        return true;
    }
}
