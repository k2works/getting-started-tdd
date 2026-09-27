<?php

declare(strict_types=1);

namespace アプリ;

/** 題材 C: 不変データとパイプライン処理 */
function 装飾(string $文字列): string
{
    return "[{$文字列}]";
}

/**
 * 「先して後」を左から右へ合成する（PHP 8.4 にはパイプ演算子 |> がないため）
 *
 * @template 入力
 * @template 途中
 * @template 出力
 * @param callable(入力): 途中 $先
 * @param callable(途中): 出力 $後
 * @return \Closure(入力): 出力
 */
function して(callable $先, callable $後): \Closure
{
    return static fn (mixed $値): mixed => $後($先($値));
}

/** N を FizzBuzz変換して 装飾して 戻す */
function FizzBuzz装飾(int $数): string
{
    return して(FizzBuzz変換(...), 装飾(...))($数);
}

/** @return list<string> */
function パイプライン処理(int $上限): array
{
    return array_map(FizzBuzz装飾(...), range(1, $上限));
}
