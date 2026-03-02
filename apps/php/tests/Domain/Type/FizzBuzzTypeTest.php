<?php

declare(strict_types=1);

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
        $this->assertSame('1', $type->generate(1)->getValue());
    }

    public function test_タイプ1_3の倍数でFizzを返す(): void
    {
        $type = new FizzBuzzType01();
        $this->assertSame('Fizz', $type->generate(3)->getValue());
    }

    public function test_タイプ1_5の倍数でBuzzを返す(): void
    {
        $type = new FizzBuzzType01();
        $this->assertSame('Buzz', $type->generate(5)->getValue());
    }

    public function test_タイプ1_15の倍数でFizzBuzzを返す(): void
    {
        $type = new FizzBuzzType01();
        $this->assertSame('FizzBuzz', $type->generate(15)->getValue());
    }

    public function test_タイプ2_常に数値を返す(): void
    {
        $type = new FizzBuzzType02();
        $this->assertSame('3', $type->generate(3)->getValue());
    }

    public function test_タイプ3_FizzBuzzのみ返す(): void
    {
        $type = new FizzBuzzType03();
        $this->assertSame('FizzBuzz', $type->generate(15)->getValue());
    }

    public function test_タイプ3_FizzBuzz以外は数値を返す(): void
    {
        $type = new FizzBuzzType03();
        $this->assertSame('3', $type->generate(3)->getValue());
    }

    public function test_列挙型でタイプを生成する(): void
    {
        $type = \App\Domain\Type\FizzBuzzTypeName::Standard->createType();
        $result = $type->generate(3);
        $this->assertSame('Fizz', $result->getValue());
    }

    public function test_全ての列挙型でタイプを生成できる(): void
    {
        foreach (\App\Domain\Type\FizzBuzzTypeName::cases() as $name) {
            $type = $name->createType();
            $this->assertInstanceOf(\App\Domain\Type\FizzBuzzType::class, $type);
        }
    }

    public function test_列挙型のラベルを取得する(): void
    {
        $this->assertSame('通常', \App\Domain\Type\FizzBuzzTypeName::Standard->label());
        $this->assertSame('数値のみ', \App\Domain\Type\FizzBuzzTypeName::NumberOnly->label());
        $this->assertSame('FizzBuzzのみ', \App\Domain\Type\FizzBuzzTypeName::FizzBuzzOnly->label());
    }
}
