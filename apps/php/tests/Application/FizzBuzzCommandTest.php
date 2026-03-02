<?php

declare(strict_types=1);

namespace App\Tests\Application;

use App\Application\FizzBuzzListCommand;
use App\Application\FizzBuzzValueCommand;
use App\Domain\Model\FizzBuzzList;
use App\Domain\Model\FizzBuzzValue;
use App\Domain\Type\FizzBuzzType01;
use PHPUnit\Framework\TestCase;

final class FizzBuzzCommandTest extends TestCase
{
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

    public function test_FizzBuzzListCommandで上限超過の例外(): void
    {
        $this->expectException(\InvalidArgumentException::class);
        $type = new FizzBuzzType01();
        new FizzBuzzListCommand($type, 101);
    }
}
