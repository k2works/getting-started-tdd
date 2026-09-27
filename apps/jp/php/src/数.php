<?php

declare(strict_types=1);

namespace アプリ;

/** 語順の再現: 数(3)->を->FizzBuzz変換() と書くための数の包み */
final readonly class 数
{
    /** 助詞「を」に相当する、自分自身を指すプロパティ */
    public 数 $を;

    public function __construct(public int $値)
    {
        $this->を = $this;
    }

    public function FizzBuzz変換(): 文
    {
        return new 文(\アプリ\FizzBuzz変換($this->値));
    }
}
