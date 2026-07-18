package fizzbuzz

import kotlin.test.Test
import kotlin.test.assertEquals
import kotlin.test.assertNull
import kotlin.test.assertTrue

class FizzBuzzErrorTest {
    @Test fun `正の数は成功を返す`() =
        assertEquals("Fizz", FizzBuzzError.safeConvert(3).getOrNull())

    @Test fun `ゼロ以下は失敗を返す`() =
        assertTrue(FizzBuzzError.safeConvert(0).isFailure)

    @Test fun `null は null を返す`() = assertNull(FizzBuzzError.convertOrNull(null))

    @Test fun `非 null は変換される`() = assertEquals("Fizz", FizzBuzzError.convertOrNull(3))
}
