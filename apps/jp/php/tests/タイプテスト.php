<?php

declare(strict_types=1);

namespace アプリ\テスト;

use PHPUnit\Framework\Attributes\Test;
use PHPUnit\Framework\Attributes\TestDox;
use PHPUnit\Framework\TestCase;
use アプリ\タイプ;
use アプリ\タイプ不明例外;

#[TestDox('タイプ')]
final class タイプテスト extends TestCase
{
    #[Test]
    #[TestDox('タイプ1は通常の変換をする')]
    public function タイプ1は通常の変換をする(): void
    {
        $タイプ = タイプ::生成(1);
        $this->assertSame('Fizz', タイプ::変換($タイプ, 3));
        $this->assertSame('通常', $タイプ->名前());
    }

    #[Test]
    #[TestDox('タイプ2は数字だけを返す')]
    public function タイプ2は数字だけを返す(): void
    {
        $タイプ = タイプ::生成(2);
        $this->assertSame('3', タイプ::変換($タイプ, 3));
        $this->assertSame('数字限定', $タイプ->名前());
    }

    #[Test]
    #[TestDox('タイプ3は15の倍数だけFizzBuzzを返す')]
    public function タイプ3は15の倍数だけFizzBuzzを返す(): void
    {
        $this->assertSame('FizzBuzz', タイプ::変換(タイプ::生成(3), 15));
    }

    #[Test]
    #[TestDox('タイプ3は3の倍数を数字で返す')]
    public function タイプ3は3の倍数を数字で返す(): void
    {
        $this->assertSame('3', タイプ::変換(タイプ::生成(3), 3));
    }

    #[Test]
    #[TestDox('存在しないタイプはエラーになる')]
    public function 存在しないタイプはエラーになる(): void
    {
        $this->expectException(タイプ不明例外::class);
        $this->expectExceptionMessage('該当するタイプは存在しません: 4');
        タイプ::生成(4);
    }
}
