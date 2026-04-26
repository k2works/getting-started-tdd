<?php

namespace App\Tests\Domain\Model;

use App\Domain\FizzBuzzException;
use App\Domain\Model\FizzBuzzValue;
use PHPUnit\Framework\TestCase;

final class FizzBuzzValueTest extends TestCase
{
    public function test_正の値で生成できる(): void
    {
        $value = new FizzBuzzValue(1, '1');

        $this->assertSame(1, $value->getNumber());
        $this->assertSame('1', $value->getValue());
    }

    public function test_負の値で例外を発生する(): void
    {
        $this->expectException(FizzBuzzException::class);

        new FizzBuzzValue(-1, '-1');
    }

    public function test_負の値でカスタム例外を発生する(): void
    {
        $this->expectException(FizzBuzzException::class);

        new FizzBuzzValue(-1, '-1');
    }

    public function test_同じ値は等しい(): void
    {
        $v1 = new FizzBuzzValue(1, '1');
        $v2 = new FizzBuzzValue(1, '1');

        $this->assertTrue($v1->equals($v2));
    }

    public function test_異なる値は等しくない(): void
    {
        $v1 = new FizzBuzzValue(1, '1');
        $v2 = new FizzBuzzValue(2, '2');

        $this->assertFalse($v1->equals($v2));
    }

    public function test_文字列表現を返す(): void
    {
        $value = new FizzBuzzValue(3, 'Fizz');

        $this->assertSame('Fizz', (string) $value);
    }
}
