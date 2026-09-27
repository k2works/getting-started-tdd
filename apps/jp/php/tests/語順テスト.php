<?php

declare(strict_types=1);

namespace アプリ\テスト;

use PHPUnit\Framework\Attributes\Test;
use PHPUnit\Framework\Attributes\TestDox;
use PHPUnit\Framework\TestCase;

use function アプリ\数;

#[TestDox('語順の再現')]
final class 語順テスト extends TestCase
{
    #[Test]
    #[TestDox('数(3)->を->FizzBuzz変換() と助詞を置いて書ける')]
    public function 助詞を置いたSOV順(): void
    {
        $this->assertSame('Fizz', 数(3)->を->FizzBuzz変換()->値);
    }

    #[Test]
    #[TestDox('15 を FizzBuzz変換して 装飾する（メソッドチェーン）')]
    public function 変換して装飾する(): void
    {
        $this->assertSame('[FizzBuzz]', 数(15)->を->FizzBuzz変換()->して->装飾()->値);
    }
}
