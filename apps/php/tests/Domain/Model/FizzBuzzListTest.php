<?php

namespace App\Tests\Domain\Model;

use App\Application\FizzBuzzListCommand;
use App\Domain\Model\FizzBuzzList;
use App\Domain\Model\FizzBuzzValue;
use App\Domain\Type\FizzBuzzType01;
use PHPUnit\Framework\TestCase;

final class FizzBuzzListTest extends TestCase
{
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

    public function test_アロー関数でFizzを判定する(): void
    {
        $isFizz = fn (FizzBuzzValue $value): bool => $value->getValue() === 'Fizz';
        $value = new FizzBuzzValue(3, 'Fizz');

        $this->assertTrue($isFizz($value));
    }

    public function test_FilterでFizzだけを抽出する(): void
    {
        $type = new FizzBuzzType01();
        $command = new FizzBuzzListCommand($type, 15);
        $list = $command->execute();

        $isFizz = fn (FizzBuzzValue $value): bool => $value->getValue() === 'Fizz';
        $filtered = $list->filter($isFizz);

        foreach ($filtered->getValue() as $value) {
            $this->assertSame('Fizz', $value->getValue());
        }
    }

    public function test_Mapで値を変換する(): void
    {
        $values = [
            new FizzBuzzValue(1, '1'),
            new FizzBuzzValue(3, 'Fizz'),
        ];
        $list = new FizzBuzzList($values);

        $toUpper = fn (FizzBuzzValue $value): string => strtoupper($value->getValue());
        $result = $list->map($toUpper);

        $this->assertSame(['1', 'FIZZ'], $result);
    }

    public function test_述語関数を生成して使用する(): void
    {
        $makeValuePredicate = fn (string $target): \Closure =>
            fn (FizzBuzzValue $value): bool => $value->getValue() === $target;

        $isFizz = $makeValuePredicate('Fizz');
        $isBuzz = $makeValuePredicate('Buzz');

        $value = new FizzBuzzValue(3, 'Fizz');
        $this->assertTrue($isFizz($value));
        $this->assertFalse($isBuzz($value));
    }

    public function test_FilterとMapを組み合わせる(): void
    {
        $type = new FizzBuzzType01();
        $command = new FizzBuzzListCommand($type, 15);
        $list = $command->execute();

        $isFizz = fn (FizzBuzzValue $value): bool => $value->getValue() === 'Fizz';
        $getValue = fn (FizzBuzzValue $value): string => $value->getValue();
        $result = $list->filter($isFizz)->map($getValue);

        foreach ($result as $value) {
            $this->assertSame('Fizz', $value);
        }
    }
}
