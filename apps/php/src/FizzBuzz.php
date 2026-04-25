<?php

namespace App;

class FizzBuzz
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
