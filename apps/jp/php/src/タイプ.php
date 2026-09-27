<?php

declare(strict_types=1);

namespace アプリ;

/** 題材 B: タイプ別の変換（列挙型によるポリモーフィズム） */
enum タイプ: int
{
    case 通常 = 1;
    case 数字限定 = 2;
    case FizzBuzz限定 = 3;

    public static function 生成(int $番号): self
    {
        return self::tryFrom($番号) ?? throw new タイプ不明例外("該当するタイプは存在しません: {$番号}");
    }

    public static function 変換(self $タイプ, int $数): string
    {
        return match ($タイプ) {
            self::通常 => FizzBuzz変換($数),
            self::数字限定 => (string) $数,
            self::FizzBuzz限定 => $数 % 15 === 0 ? 'FizzBuzz' : (string) $数,
        };
    }

    public function 名前(): string
    {
        return $this->name;
    }
}
