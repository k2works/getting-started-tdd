<?php

declare(strict_types=1);

namespace アプリ\テスト;

use PHPUnit\Framework\Attributes\TestDox;
use PHPUnit\Framework\TestCase;

use function アプリ\FizzBuzz変換;
use function アプリ\FizzBuzz配列作成;

#[TestDox('FizzBuzz変換')]
final class FizzBuzz変換テスト extends TestCase
{
    #[TestDox('3を渡したらFizzを返す')]
    public function test_3を渡したらFizzを返す(): void
    {
        $this->assertSame('Fizz', FizzBuzz変換(3));
    }

    #[TestDox('5を渡したらBuzzを返す')]
    public function test_5を渡したらBuzzを返す(): void
    {
        $this->assertSame('Buzz', FizzBuzz変換(5));
    }

    #[TestDox('15を渡したらFizzBuzzを返す')]
    public function test_15を渡したらFizzBuzzを返す(): void
    {
        $this->assertSame('FizzBuzz', FizzBuzz変換(15));
    }

    #[TestDox('1を渡したら文字列1を返す')]
    public function test_1を渡したら文字列1を返す(): void
    {
        $this->assertSame('1', FizzBuzz変換(1));
    }

    #[TestDox('2を渡したら文字列2を返す')]
    public function test_2を渡したら文字列2を返す(): void
    {
        $this->assertSame('2', FizzBuzz変換(2));
    }

    #[TestDox('15まで作ると15件になる')]
    public function test_15まで作ると15件になる(): void
    {
        $this->assertCount(15, FizzBuzz配列作成(15));
    }

    #[TestDox('15まで作った配列の並び')]
    public function test_15まで作った配列の並び(): void
    {
        $this->assertSame(
            '1,2,Fizz,4,Buzz,Fizz,7,8,Fizz,Buzz,11,Fizz,13,14,FizzBuzz',
            implode(',', FizzBuzz配列作成(15))
        );
    }
}
