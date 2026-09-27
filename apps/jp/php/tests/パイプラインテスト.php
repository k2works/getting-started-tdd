<?php

declare(strict_types=1);

namespace アプリ\テスト;

use PHPUnit\Framework\Attributes\Test;
use PHPUnit\Framework\Attributes\TestDox;
use PHPUnit\Framework\TestCase;

use function アプリ\パイプライン処理;
use function アプリ\装飾;

#[TestDox('パイプライン')]
final class パイプラインテスト extends TestCase
{
    #[Test]
    #[TestDox('装飾すると角括弧で囲む')]
    public function 装飾すると角括弧で囲む(): void
    {
        $this->assertSame('[Fizz]', 装飾('Fizz'));
    }

    #[Test]
    #[TestDox('5までのパイプライン処理')]
    public function test_5までのパイプライン処理(): void
    {
        $this->assertSame(['[1]', '[2]', '[Fizz]', '[4]', '[Buzz]'], パイプライン処理(5));
    }
}
