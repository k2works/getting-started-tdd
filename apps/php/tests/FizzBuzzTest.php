<?php

namespace App\Tests;

use App\FizzBuzz;
use App\FizzBuzzListCommand;
use App\FizzBuzzList;
use App\FizzBuzzValue;
use App\FizzBuzzValueCommand;
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

    public function test_正の値で生成できる(): void
    {
        $value = new FizzBuzzValue(1, '1');

        $this->assertSame(1, $value->getNumber());
        $this->assertSame('1', $value->getValue());
    }

    public function test_負の値で例外を発生する(): void
    {
        $this->expectException(\InvalidArgumentException::class);

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

    public function test_配列からリストを生成する(): void
    {
        $values = [
            new FizzBuzzValue(1, '1'),
            new FizzBuzzValue(2, '2'),
        ];
        $list = new FizzBuzzList($values);

        $this->assertSame(2, $list->count());
    }

    public function test_上限を超えると例外を発生する(): void
    {
        $this->expectException(\InvalidArgumentException::class);

        $values = [];
        for ($i = 0; $i <= 100; $i++) {
            $values[] = new FizzBuzzValue($i, (string) $i);
        }

        new FizzBuzzList($values);
    }

    public function test_文字列配列を返す(): void
    {
        $values = [
            new FizzBuzzValue(1, '1'),
            new FizzBuzzValue(3, 'Fizz'),
        ];
        $list = new FizzBuzzList($values);

        $this->assertSame(['1', 'Fizz'], $list->toStringArray());
    }

    public function test_リストの文字列表現を返す(): void
    {
        $values = [
            new FizzBuzzValue(1, '1'),
            new FizzBuzzValue(3, 'Fizz'),
        ];
        $list = new FizzBuzzList($values);

        $this->assertSame('1,Fizz', (string) $list);
    }

    public function test_FizzBuzzValueCommandで値を生成する(): void
    {
        $type = new FizzBuzzType01();
        $command = new FizzBuzzValueCommand($type);
        $result = $command->execute(3);

        $this->assertInstanceOf(FizzBuzzValue::class, $result);
        $this->assertSame('Fizz', $result->getValue());
    }

    public function test_FizzBuzzListCommandでリストを生成する(): void
    {
        $type = new FizzBuzzType01();
        $command = new FizzBuzzListCommand($type);
        $result = $command->execute();

        $this->assertInstanceOf(FizzBuzzList::class, $result);
        $this->assertSame(100, $result->count());
    }
}
