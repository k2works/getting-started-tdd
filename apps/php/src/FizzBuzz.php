<?php

declare(strict_types=1);

namespace App;

final class FizzBuzz
{
    public function generate(int $number): string
    {
        if ($number % 15 === 0) {
            return 'FizzBuzz';
        }

        if ($number % 3 === 0) {
            return 'Fizz';
        }

        if ($number % 5 === 0) {
            return 'Buzz';
        }

        return (string) $number;
    }

    /**
     * @return string[]
     */
    public function generateList(): array
    {
        $results = [];

        for ($number = 1; $number <= 100; $number++) {
            $results[] = $this->generate($number);
        }

        return $results;
    }

    public function printFizzBuzz(): void
    {
        echo implode(PHP_EOL, $this->generateList()) . PHP_EOL;
    }
}
