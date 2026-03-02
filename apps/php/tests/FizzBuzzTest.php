<?php

declare(strict_types=1);

namespace App\Tests;

use App\FizzBuzz;
use PHPUnit\Framework\TestCase;

final class FizzBuzzTest extends TestCase
{
    public function test_1を渡したら文字列1を返す(): void
    {
        $fizzBuzz = new FizzBuzz();
        $actual = $fizzBuzz->generate(1);
        $this->assertSame('1', $actual);
    }

    public function test_2を渡したら文字列2を返す(): void
    {
        $fizzBuzz = new FizzBuzz();
        $actual = $fizzBuzz->generate(2);
        $this->assertSame('2', $actual);
    }

    public function test_3を渡したら文字列Fizzを返す(): void
    {
        $fizzBuzz = new FizzBuzz();
        $actual = $fizzBuzz->generate(3);
        $this->assertSame('Fizz', $actual);
    }

    public function test_5を渡したら文字列Buzzを返す(): void
    {
        $fizzBuzz = new FizzBuzz();
        $actual = $fizzBuzz->generate(5);
        $this->assertSame('Buzz', $actual);
    }

    public function test_15を渡したら文字列FizzBuzzを返す(): void
    {
        $fizzBuzz = new FizzBuzz();
        $actual = $fizzBuzz->generate(15);
        $this->assertSame('FizzBuzz', $actual);
    }

    public function test_6を渡したら文字列Fizzを返す(): void
    {
        $fizzBuzz = new FizzBuzz();
        $actual = $fizzBuzz->generate(6);
        $this->assertSame('Fizz', $actual);
    }

    public function test_10を渡したら文字列Buzzを返す(): void
    {
        $fizzBuzz = new FizzBuzz();
        $actual = $fizzBuzz->generate(10);
        $this->assertSame('Buzz', $actual);
    }

    public function test_30を渡したら文字列FizzBuzzを返す(): void
    {
        $fizzBuzz = new FizzBuzz();
        $actual = $fizzBuzz->generate(30);
        $this->assertSame('FizzBuzz', $actual);
    }

    public function test_1から100までのFizzBuzz配列を返す(): void
    {
        $fizzBuzz = new FizzBuzz();
        $actual = $fizzBuzz->generateList();
        $this->assertCount(100, $actual);
        $this->assertSame('1', $actual[0]);
        $this->assertSame('2', $actual[1]);
        $this->assertSame('Fizz', $actual[2]);
        $this->assertSame('Buzz', $actual[4]);
        $this->assertSame('FizzBuzz', $actual[14]);
        $this->assertSame('Buzz', $actual[99]);
    }

    public function test_FizzBuzzをプリントする(): void
    {
        $fizzBuzz = new FizzBuzz();
        ob_start();
        $fizzBuzz->printFizzBuzz();
        $actual = ob_get_clean();
        $expected = implode(PHP_EOL, $fizzBuzz->generateList()) . PHP_EOL;
        $this->assertSame($expected, $actual);
    }

    public function test_ファクトリメソッドでタイプ1を生成する(): void
    {
        $type = FizzBuzz::create(1);
        $result = $type->generate(3);
        $this->assertSame('Fizz', $result->getValue());
    }

    public function test_不正なタイプで例外を発生する(): void
    {
        $this->expectException(\InvalidArgumentException::class);
        FizzBuzz::create(99);
    }
}
