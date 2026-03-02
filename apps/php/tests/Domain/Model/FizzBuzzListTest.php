<?php

declare(strict_types=1);

namespace App\Tests\Domain\Model;

use App\Domain\Model\FizzBuzzList;
use App\Domain\Model\FizzBuzzValue;
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

    public function test_文字列表現を返す(): void
    {
        $values = [
            new FizzBuzzValue(1, '1'),
            new FizzBuzzValue(3, 'Fizz'),
        ];
        $list = new FizzBuzzList($values);
        $this->assertSame('1,Fizz', (string) $list);
    }

    public function test_filterでFizzだけを抽出する(): void
    {
        $type = new \App\Domain\Type\FizzBuzzType01();
        $command = new \App\Application\FizzBuzzListCommand($type, 15);
        $list = $command->execute();

        $isFizz = fn (FizzBuzzValue $v): bool => $v->getValue() === 'Fizz';
        $filtered = $list->filter($isFizz);

        foreach ($filtered->getValue() as $v) {
            $this->assertSame('Fizz', $v->getValue());
        }
    }

    public function test_mapで値を変換する(): void
    {
        $values = [
            new FizzBuzzValue(1, '1'),
            new FizzBuzzValue(3, 'Fizz'),
        ];
        $list = new FizzBuzzList($values);

        $toUpper = fn (FizzBuzzValue $v): string => strtoupper($v->getValue());
        $result = $list->map($toUpper);

        $this->assertSame(['1', 'FIZZ'], $result);
    }

    public function test_groupByValueで値でグルーピングする(): void
    {
        $type = new \App\Domain\Type\FizzBuzzType01();
        $command = new \App\Application\FizzBuzzListCommand($type, 15);
        $list = $command->execute();

        $grouped = $list->groupByValue();

        $this->assertArrayHasKey('Fizz', $grouped);
        $this->assertArrayHasKey('Buzz', $grouped);
        $this->assertArrayHasKey('FizzBuzz', $grouped);
    }

    public function test_countByValueで値ごとの出現回数を数える(): void
    {
        $type = new \App\Domain\Type\FizzBuzzType01();
        $command = new \App\Application\FizzBuzzListCommand($type, 15);
        $list = $command->execute();

        $counts = $list->countByValue();

        $this->assertSame(1, $counts['FizzBuzz']);
    }

    public function test_takeで先頭N件を取得する(): void
    {
        $type = new \App\Domain\Type\FizzBuzzType01();
        $command = new \App\Application\FizzBuzzListCommand($type, 15);
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

    public function test_reduceで数値の合計を計算する(): void
    {
        $values = [
            new FizzBuzzValue(1, '1'),
            new FizzBuzzValue(2, '2'),
            new FizzBuzzValue(3, 'Fizz'),
        ];
        $list = new FizzBuzzList($values);

        $sum = $list->reduce(0, fn (int $acc, FizzBuzzValue $v): int => $acc + $v->getNumber());

        $this->assertSame(6, $sum);
    }

    public function test_filterは元のリストを変更しない(): void
    {
        $type = new \App\Domain\Type\FizzBuzzType01();
        $command = new \App\Application\FizzBuzzListCommand($type, 15);
        $original = $command->execute();
        $originalCount = $original->count();

        $isFizz = fn (FizzBuzzValue $v): bool => $v->getValue() === 'Fizz';
        $original->filter($isFizz);

        $this->assertSame($originalCount, $original->count());
    }

    public function test_メソッドチェーンでパイプラインを構築する(): void
    {
        $type = new \App\Domain\Type\FizzBuzzType01();
        $command = new \App\Application\FizzBuzzListCommand($type);
        $list = $command->execute();

        $result = $list
            ->filter(fn (FizzBuzzValue $v): bool => $v->getValue() === 'Fizz')
            ->take(3)
            ->join(', ');

        $this->assertSame('Fizz, Fizz, Fizz', $result);
    }

    public function test_findFirstで最初のFizzBuzzを見つける(): void
    {
        $type = new \App\Domain\Type\FizzBuzzType01();
        $command = new \App\Application\FizzBuzzListCommand($type);
        $list = $command->execute();

        $isFizzBuzz = fn (FizzBuzzValue $v): bool => $v->getValue() === 'FizzBuzz';
        $result = $list->findFirst($isFizzBuzz);

        $this->assertNotNull($result);
        $this->assertSame(15, $result->getNumber());
    }

    public function test_findFirstで見つからない場合nullを返す(): void
    {
        $values = [new FizzBuzzValue(1, '1')];
        $list = new FizzBuzzList($values);

        $isFizzBuzz = fn (FizzBuzzValue $v): bool => $v->getValue() === 'FizzBuzz';
        $result = $list->findFirst($isFizzBuzz);

        $this->assertNull($result);
    }

    public function test_anyMatchでFizzが存在する(): void
    {
        $type = new \App\Domain\Type\FizzBuzzType01();
        $command = new \App\Application\FizzBuzzListCommand($type, 15);
        $list = $command->execute();

        $isFizz = fn (FizzBuzzValue $v): bool => $v->getValue() === 'Fizz';
        $this->assertTrue($list->anyMatch($isFizz));
    }

    public function test_allMatchで全て数値ではない(): void
    {
        $type = new \App\Domain\Type\FizzBuzzType01();
        $command = new \App\Application\FizzBuzzListCommand($type, 15);
        $list = $command->execute();

        $isNumber = fn (FizzBuzzValue $v): bool =>
            $v->getValue() !== 'Fizz'
            && $v->getValue() !== 'Buzz'
            && $v->getValue() !== 'FizzBuzz';
        $this->assertFalse($list->allMatch($isNumber));
    }

    public function test_allMatchで全て数値である(): void
    {
        $type = new \App\Domain\Type\FizzBuzzType02();
        $command = new \App\Application\FizzBuzzListCommand($type, 15);
        $list = $command->execute();

        $isNumber = fn (FizzBuzzValue $v): bool => ctype_digit($v->getValue());
        $this->assertTrue($list->allMatch($isNumber));
    }
}
