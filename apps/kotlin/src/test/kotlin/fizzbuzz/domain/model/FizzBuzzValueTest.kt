package fizzbuzz.domain.model

import fizzbuzz.domain.type.FizzBuzzType
import kotlin.test.Test
import kotlin.test.assertEquals

class FizzBuzzValueTest {
    @Test fun `値オブジェクトは数値を保持する`() =
        assertEquals(3, FizzBuzzValue.create(FizzBuzzType.TYPE_01, 3).number)

    @Test fun `値オブジェクトは変換結果を保持する`() =
        assertEquals("Fizz", FizzBuzzValue.create(FizzBuzzType.TYPE_01, 3).value)

    @Test fun `data class は等値比較できる`() =
        assertEquals(FizzBuzzValue(3, "Fizz"), FizzBuzzValue.create(FizzBuzzType.TYPE_01, 3))

    @Test fun `100 件のコレクションを生成する`() =
        assertEquals(100, FizzBuzzList.create(100, FizzBuzzType.TYPE_01).count)

    @Test fun `コレクションの 15 番目は FizzBuzz`() =
        assertEquals("FizzBuzz", FizzBuzzList.create(100, FizzBuzzType.TYPE_01).values[14].value)
}
