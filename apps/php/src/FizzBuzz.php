<?php

declare(strict_types=1);

namespace App;

use App\Domain\Type\FizzBuzzType;
use App\Domain\Type\FizzBuzzType01;
use App\Domain\Type\FizzBuzzType02;
use App\Domain\Type\FizzBuzzType03;

final class FizzBuzz
{
    public static function create(int $type): FizzBuzzType
    {
        return match ($type) {
            1 => new FizzBuzzType01(),
            2 => new FizzBuzzType02(),
            3 => new FizzBuzzType03(),
            default => throw new \InvalidArgumentException("タイプ{$type}は見つかりません"),
        };
    }

    public function generate(int $number): string
    {
        $type = new FizzBuzzType01();

        return $type->generate($number)->getValue();
    }

    /**
     * @return string[]
     */
    public function generateList(): array
    {
        $type = new FizzBuzzType01();
        $results = [];

        for ($i = 1; $i <= 100; $i++) {
            $results[] = $type->generate($i)->getValue();
        }

        return $results;
    }

    public function printFizzBuzz(): void
    {
        echo implode(PHP_EOL, $this->generateList()) . PHP_EOL;
    }
}
