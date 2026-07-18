package fizzbuzz

import kotlin.test.Test
import kotlin.test.assertEquals

class FizzBuzzTest {
    @Test
    fun `1 を渡したら文字列 1 を返す`() {
        assertEquals("1", FizzBuzz.convert(1))
    }
}
