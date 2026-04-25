<?php

namespace App\Tests;

use PHPUnit\Framework\TestCase;

class LearningTest extends TestCase
{
    public function test_PHPの文字列キャストを確認する(): void
    {
        $this->assertSame('42', (string) 42);
    }

    public function test_PHPのintval関数を確認する(): void
    {
        $this->assertSame(42, intval('42'));
    }
}
