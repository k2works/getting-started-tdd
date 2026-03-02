<?php

declare(strict_types=1);

namespace App\Domain\Type;

enum FizzBuzzTypeName: int
{
    case Standard = 1;
    case NumberOnly = 2;
    case FizzBuzzOnly = 3;

    public function createType(): FizzBuzzType
    {
        return match ($this) {
            self::Standard => new FizzBuzzType01(),
            self::NumberOnly => new FizzBuzzType02(),
            self::FizzBuzzOnly => new FizzBuzzType03(),
        };
    }

    public function label(): string
    {
        return match ($this) {
            self::Standard => '通常',
            self::NumberOnly => '数値のみ',
            self::FizzBuzzOnly => 'FizzBuzzのみ',
        };
    }
}
