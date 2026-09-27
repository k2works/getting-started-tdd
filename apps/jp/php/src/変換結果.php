<?php

declare(strict_types=1);

namespace アプリ;

/** 題材 D: 成功・失敗を表す値オブジェクト */
final readonly class 変換結果
{
    private function __construct(
        public bool $成功,
        public ?string $値,
        public ?string $エラー,
    ) {
    }

    public static function 成功(string $値): self
    {
        return new self(true, $値, null);
    }

    public static function 失敗(string $エラー): self
    {
        return new self(false, null, $エラー);
    }
}
