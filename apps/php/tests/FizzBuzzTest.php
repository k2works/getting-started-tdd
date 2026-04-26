<?php

namespace App\Tests;

use App\Domain\FizzBuzzException;
use App\FizzBuzz;
use PHPUnit\Framework\TestCase;

class FizzBuzzTest extends TestCase
{
    public function test_1を渡したら文字列1を返す(): void
    {
        $fizzbuzz = new FizzBuzz();
        $this->assertSame('1', $fizzbuzz->generate(1));
    }

    public function test_2を渡したら文字列2を返す(): void
    {
        $fizzbuzz = new FizzBuzz();
        $this->assertSame('2', $fizzbuzz->generate(2));
    }

    public function test_3を渡したら文字列Fizzを返す(): void
    {
        $fizzbuzz = new FizzBuzz();
        $this->assertSame('Fizz', $fizzbuzz->generate(3));
    }

    public function test_5を渡したら文字列Buzzを返す(): void
    {
        $fizzbuzz = new FizzBuzz();
        $this->assertSame('Buzz', $fizzbuzz->generate(5));
    }

    public function test_15を渡したら文字列FizzBuzzを返す(): void
    {
        $fizzbuzz = new FizzBuzz();
        $this->assertSame('FizzBuzz', $fizzbuzz->generate(15));
    }

    public function test_6を渡したら文字列Fizzを返す(): void
    {
        $fizzbuzz = new FizzBuzz();
        $this->assertSame('Fizz', $fizzbuzz->generate(6));
    }

    public function test_10を渡したら文字列Buzzを返す(): void
    {
        $fizzbuzz = new FizzBuzz();
        $this->assertSame('Buzz', $fizzbuzz->generate(10));
    }

    public function test_30を渡したら文字列FizzBuzzを返す(): void
    {
        $fizzbuzz = new FizzBuzz();
        $this->assertSame('FizzBuzz', $fizzbuzz->generate(30));
    }

    public function test_1から100までのFizzBuzz配列を返す(): void
    {
        $fizzbuzz = new FizzBuzz();
        $result = $fizzbuzz->generateList();

        $this->assertSame('1', $result[0]);
        $this->assertSame('Fizz', $result[2]);
        $this->assertSame('Buzz', $result[4]);
        $this->assertSame('FizzBuzz', $result[14]);
        $this->assertSame('Buzz', $result[99]);
        $this->assertCount(100, $result);
    }

    public function test_FizzBuzzをプリントする(): void
    {
        $fizzbuzz = new FizzBuzz();

        ob_start();
        $fizzbuzz->printFizzBuzz();
        $output = ob_get_clean();

        $lines = explode("\n", trim($output));
        $this->assertSame('1', $lines[0]);
        $this->assertSame('Fizz', $lines[2]);
        $this->assertSame('Buzz', $lines[4]);
        $this->assertSame('FizzBuzz', $lines[14]);
        $this->assertSame('Buzz', $lines[99]);
        $this->assertCount(100, $lines);
    }

    public function test_ファクトリメソッドでタイプ1を生成する(): void
    {
        $type = FizzBuzz::create(1);
        $result = $type->generate(3);

        $this->assertSame('Fizz', $result->getValue());
    }

    public function test_不正なタイプで例外を発生する(): void
    {
        $this->expectException(FizzBuzzException::class);

        FizzBuzz::create(4);
    }

    public function test_不正なタイプでカスタム例外を発生する(): void
    {
        $this->expectException(FizzBuzzException::class);
        $this->expectExceptionMessage('タイプ99は見つかりません');

        FizzBuzz::create(99);
    }
}
