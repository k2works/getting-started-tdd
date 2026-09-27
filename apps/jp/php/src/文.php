<?php

declare(strict_types=1);

namespace アプリ;

/** 語順の再現: 変換後の文字列の包み */
final readonly class 文
{
    /** 「〜して」に相当する、自分自身を指すプロパティ */
    public 文 $して;

    public function __construct(public string $値)
    {
        $this->して = $this;
    }

    public function 装飾(): self
    {
        return new self(\アプリ\装飾($this->値));
    }
}
