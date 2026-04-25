<?php

namespace App\Tests\Domain\Type;

use App\Domain\Type\FizzBuzzType01;
use App\Domain\Type\FizzBuzzType02;
use App\Domain\Type\FizzBuzzType03;
use PHPUnit\Framework\TestCase;

final class FizzBuzzTypeTest extends TestCase
{
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
}
