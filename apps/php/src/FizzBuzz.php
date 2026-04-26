<?php

namespace App;

use App\Domain\FizzBuzzException;
use App\Domain\Type\FizzBuzzType;
use App\Domain\Type\FizzBuzzTypeName;

class FizzBuzz
{
    public static function create(int $type): FizzBuzzType
    {
        return FizzBuzzTypeName::tryFrom($type)?->createType()
            ?? throw new FizzBuzzException("タイプ{$type}は見つかりません");
    }

    public function generate(int $number): string
    {
        $type = self::create(1);

        return $type->generate($number)->getValue();
    }

    /**
     * @return string[]
     */
    public function generateList(): array
    {
        $result = [];
        for ($i = 1; $i <= 100; $i++) {
            $result[] = $this->generate($i);
        }

        return $result;
    }

    public function printFizzBuzz(): void
    {
        $list = $this->generateList();
        foreach ($list as $item) {
            echo $item . "\n";
        }
    }
}
