<?php

namespace App\Tests;

use App\FizzBuzz;
use App\FizzBuzzType01;
use App\FizzBuzzType02;
use App\FizzBuzzType03;
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

    public function test_タイプ1_数を文字列に変換する(): void
    {
        $type = new FizzBuzzType01();
        $result = $type->generate(1);

        $this->assertSame('1', $result->getValue());
    }

    public function test_タイプ1_3の倍数でFizzを返す(): void
    {
        $type = new FizzBuzzType01();
        $result = $type->generate(3);

        $this->assertSame('Fizz', $result->getValue());
    }

    public function test_タイプ2_常に数値を返す(): void
    {
        $type = new FizzBuzzType02();
        $result = $type->generate(3);

        $this->assertSame('3', $result->getValue());
    }

    public function test_タイプ3_FizzBuzzのみ返す(): void
    {
        $type = new FizzBuzzType03();
        $result = $type->generate(15);

        $this->assertSame('FizzBuzz', $result->getValue());
    }

    public function test_タイプ3_FizzBuzz以外は数値を返す(): void
    {
        $type = new FizzBuzzType03();
        $result = $type->generate(3);

        $this->assertSame('3', $result->getValue());
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

        FizzBuzz::create(4);
    }
}
