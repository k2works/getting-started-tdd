<?php

declare(strict_types=1);

namespace アプリ\テスト;

use PHPUnit\Framework\Attributes\Test;
use PHPUnit\Framework\Attributes\TestDox;
use PHPUnit\Framework\TestCase;

use function アプリ\安全変換;

#[TestDox('安全変換')]
final class 安全変換テスト extends TestCase
{
    #[Test]
    #[TestDox('正の数は成功になる')]
    public function 正の数は成功になる(): void
    {
        $結果 = 安全変換(3);
        $this->assertTrue($結果->成功);
        $this->assertSame('Fizz', $結果->値);
    }

    #[Test]
    #[TestDox('0は失敗になる')]
    public function test_0は失敗になる(): void
    {
        $結果 = 安全変換(0);
        $this->assertFalse($結果->成功);
        $this->assertSame('正の数を指定してください: 0', $結果->エラー);
    }

    #[Test]
    #[TestDox('数値でなければ失敗になる')]
    public function 数値でなければ失敗になる(): void
    {
        $結果 = 安全変換('a');
        $this->assertFalse($結果->成功);
        $this->assertSame('数値を指定してください: a', $結果->エラー);
    }
}
