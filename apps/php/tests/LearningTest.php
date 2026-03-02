<?php

declare(strict_types=1);

namespace App\Tests;

use PHPUnit\Framework\TestCase;

final class LearningTest extends TestCase
{
    public function test_phpの文字列キャスト確認(): void
    {
        $this->assertSame('42', (string) 42);
    }

    public function test_phpのintval関数確認(): void
    {
        $this->assertSame(42, intval('42'));
    }
}
