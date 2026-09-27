<?php

declare(strict_types=1);

namespace アプリ;

/** 題材 D: 例外を使わない安全な変換 */
function 安全変換(int|string $数): 変換結果
{
    if (!is_int($数)) {
        return 変換結果::失敗("数値を指定してください: {$数}");
    }
    if ($数 <= 0) {
        return 変換結果::失敗("正の数を指定してください: {$数}");
    }
    return 変換結果::成功(FizzBuzz変換($数));
}
