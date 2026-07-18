package fizzbuzz

import kotlin.test.Test
import kotlin.test.assertEquals
import kotlin.test.assertTrue

class FizzBuzzTypeTest {
    @Test fun `TYPE_01 は通常の FizzBuzz`() {
        assertEquals("1", FizzBuzzType.TYPE_01.generate(1))
        assertEquals("Fizz", FizzBuzzType.TYPE_01.generate(3))
        assertEquals("Buzz", FizzBuzzType.TYPE_01.generate(5))
        assertEquals("FizzBuzz", FizzBuzzType.TYPE_01.generate(15))
    }

    @Test fun `TYPE_02 は数字のみ`() = assertEquals("3", FizzBuzzType.TYPE_02.generate(3))

    @Test fun `TYPE_03 は Fizz のみで Buzz なし`() {
        assertEquals("Fizz", FizzBuzzType.TYPE_03.generate(3))
        assertEquals("5", FizzBuzzType.TYPE_03.generate(5))
        assertEquals("FizzBuzz", FizzBuzzType.TYPE_03.generate(15))
    }

    @Test fun `番号 1 は TYPE_01`() = assertEquals(FizzBuzzType.TYPE_01, FizzBuzzType.create(1).getOrNull())
    @Test fun `番号 2 は TYPE_02`() = assertEquals(FizzBuzzType.TYPE_02, FizzBuzzType.create(2).getOrNull())
    @Test fun `番号 3 は TYPE_03`() = assertEquals(FizzBuzzType.TYPE_03, FizzBuzzType.create(3).getOrNull())
    @Test fun `未定義の番号は失敗`() = assertTrue(FizzBuzzType.create(99).isFailure)
}
