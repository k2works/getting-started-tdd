package fizzbuzz.application

import fizzbuzz.domain.type.FizzBuzzType
import kotlin.test.Test
import kotlin.test.assertEquals

class FizzBuzzCommandTest {
    @Test fun `ValueCommand は単一要素のコレクション`() {
        val result = FizzBuzzCommand.ValueCommand(FizzBuzzType.TYPE_01).execute(3)
        assertEquals(1, result.count)
        assertEquals("Fizz", result.values[0].value)
    }

    @Test fun `ListCommand は 1 から n までのコレクション`() {
        val result = FizzBuzzCommand.ListCommand(FizzBuzzType.TYPE_01).execute(100)
        assertEquals(100, result.count)
    }
}
