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

    public function test_filterは元のリストを変更しない(): void
    {
        $type = new FizzBuzzType01();
        $command = new FizzBuzzListCommand($type, 15);
        $original = $command->execute();
        $originalCount = $original->count();

        $isFizz = fn (FizzBuzzValue $value): bool => $value->getValue() === 'Fizz';
        $original->filter($isFizz);

        $this->assertSame($originalCount, $original->count());
    }

    public function test_groupByValueで値でグルーピングする(): void
    {
        $type = new FizzBuzzType01();
        $command = new FizzBuzzListCommand($type, 15);
        $list = $command->execute();

        $grouped = $list->groupByValue();

        $this->assertArrayHasKey('Fizz', $grouped);
        $this->assertArrayHasKey('Buzz', $grouped);
        $this->assertArrayHasKey('FizzBuzz', $grouped);
    }

    public function test_countByValueで値ごとの出現回数を数える(): void
    {
        $type = new FizzBuzzType01();
        $command = new FizzBuzzListCommand($type, 15);
        $list = $command->execute();

        $counts = $list->countByValue();

        $this->assertSame(1, $counts['FizzBuzz']);
    }

    public function test_takeで先頭N件を取得する(): void
    {
        $type = new FizzBuzzType01();
        $command = new FizzBuzzListCommand($type, 15);
        $list = $command->execute();

        $taken = $list->take(5);

        $this->assertSame(5, $taken->count());
    }

    public function test_joinで要素を文字列で結合する(): void
    {
        $values = [
            new FizzBuzzValue(1, '1'),
            new FizzBuzzValue(2, '2'),
            new FizzBuzzValue(3, 'Fizz'),
        ];
        $list = new FizzBuzzList($values);

        $result = $list->join(', ');

        $this->assertSame('1, 2, Fizz', $result);
    }

    public function test_メソッドチェーンでパイプラインを構築する(): void
    {
        $type = new FizzBuzzType01();
        $command = new FizzBuzzListCommand($type);
        $list = $command->execute();

        $result = $list
            ->filter(fn (FizzBuzzValue $value): bool => $value->getValue() === 'Fizz')
            ->take(3)
            ->join(', ');

        $this->assertSame('Fizz, Fizz, Fizz', $result);
    }

    public function test_reduceで数値の合計を計算する(): void
    {
        $values = [
            new FizzBuzzValue(1, '1'),
            new FizzBuzzValue(2, '2'),
            new FizzBuzzValue(3, 'Fizz'),
        ];
        $list = new FizzBuzzList($values);

        $sum = $list->reduce(
            0,
            fn (int $accumulator, FizzBuzzValue $value): int => $accumulator + $value->getNumber()
        );

        $this->assertSame(6, $sum);
    }

    public function test_findFirstで最初のFizzBuzzを見つける(): void
    {
        $type = new FizzBuzzType01();
        $command = new FizzBuzzListCommand($type);
        $list = $command->execute();

        $isFizzBuzz = fn (FizzBuzzValue $value): bool => $value->getValue() === 'FizzBuzz';
        $result = $list->findFirst($isFizzBuzz);

        $this->assertNotNull($result);
        $this->assertSame(15, $result->getNumber());
    }

    public function test_findFirstで見つからない場合nullを返す(): void
    {
        $values = [new FizzBuzzValue(1, '1')];
        $list = new FizzBuzzList($values);

        $isFizzBuzz = fn (FizzBuzzValue $value): bool => $value->getValue() === 'FizzBuzz';
        $result = $list->findFirst($isFizzBuzz);

        $this->assertNull($result);
    }

    public function test_anyMatchでFizzが存在する(): void
    {
        $type = new FizzBuzzType01();
        $command = new FizzBuzzListCommand($type, 15);
        $list = $command->execute();

        $isFizz = fn (FizzBuzzValue $value): bool => $value->getValue() === 'Fizz';

        $this->assertTrue($list->anyMatch($isFizz));
    }

    public function test_allMatchで全て数値ではない(): void
    {
        $type = new FizzBuzzType01();
        $command = new FizzBuzzListCommand($type, 15);
        $list = $command->execute();

        $isNumber = fn (FizzBuzzValue $value): bool =>
            $value->getValue() !== 'Fizz'
            && $value->getValue() !== 'Buzz'
            && $value->getValue() !== 'FizzBuzz';

        $this->assertFalse($list->allMatch($isNumber));
    }
}
