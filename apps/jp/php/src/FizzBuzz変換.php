<?php

declare(strict_types=1);

namespace アプリ;

/** 題材 A: FizzBuzz の基本変換 */
function FizzBuzz変換(int $数): string
{
    return match (true) {
        $数 % 15 === 0 => 'FizzBuzz',
        $数 % 3 === 0 => 'Fizz',
        $数 % 5 === 0 => 'Buzz',
        default => (string) $数,
    };
}

/** @return list<string> */
function FizzBuzz配列作成(int $上限): array
{
    return array_map(FizzBuzz変換(...), range(1, $上限));
}
