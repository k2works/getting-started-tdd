package fizzbuzz

import kotlin.test.Test
import kotlin.test.assertEquals

class FizzBuzzTest {
    @Test fun `1 を渡したら文字列 1 を返す`() = assertEquals("1", FizzBuzz.convert(1))
    @Test fun `2 を渡したら文字列 2 を返す`() = assertEquals("2", FizzBuzz.convert(2))
    @Test fun `3 の倍数は Fizz`() = assertEquals("Fizz", FizzBuzz.convert(3))
    @Test fun `6 も Fizz`() = assertEquals("Fizz", FizzBuzz.convert(6))
    @Test fun `5 の倍数は Buzz`() = assertEquals("Buzz", FizzBuzz.convert(5))
    @Test fun `10 も Buzz`() = assertEquals("Buzz", FizzBuzz.convert(10))
    @Test fun `15 の倍数は FizzBuzz`() = assertEquals("FizzBuzz", FizzBuzz.convert(15))
    @Test fun `30 も FizzBuzz`() = assertEquals("FizzBuzz", FizzBuzz.convert(30))

    @Test fun `100 件のリストを生成する`() = assertEquals(100, FizzBuzz.generateList(100).size)
    @Test fun `最初の要素は 1`() = assertEquals("1", FizzBuzz.generateList(100)[0])
    @Test fun `3 番目の要素は Fizz`() = assertEquals("Fizz", FizzBuzz.generateList(100)[2])
    @Test fun `5 番目の要素は Buzz`() = assertEquals("Buzz", FizzBuzz.generateList(100)[4])
    @Test fun `15 番目の要素は FizzBuzz`() = assertEquals("FizzBuzz", FizzBuzz.generateList(100)[14])
}
