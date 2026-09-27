package フィズバズ

import kotlin.test.Test
import kotlin.test.assertEquals

class FizzBuzzテスト {
    @Test fun `3を渡したらFizzを返す`() = assertEquals("Fizz", FizzBuzz変換(3))

    @Test fun `5を渡したらBuzzを返す`() = assertEquals("Buzz", FizzBuzz変換(5))

    @Test fun `15を渡したらFizzBuzzを返す`() = assertEquals("FizzBuzz", FizzBuzz変換(15))

    @Test fun `1を渡したら文字列1を返す`() = assertEquals("1", FizzBuzz変換(1))

    @Test fun `2を渡したら文字列2を返す`() = assertEquals("2", FizzBuzz変換(2))

    @Test fun `15まで作ると15件になる`() = assertEquals(15, FizzBuzz配列作成(15).size)

    @Test fun `15まで作った配列の並び`() =
        assertEquals(
            "1,2,Fizz,4,Buzz,Fizz,7,8,Fizz,Buzz,11,Fizz,13,14,FizzBuzz",
            FizzBuzz配列作成(15).joinToString(","),
        )

    @Test fun `3を FizzBuzz変換 と書ける（中置関数）`() = assertEquals("Fizz", 3 を ::FizzBuzz変換)

    @Test fun `3の FizzBuzz変換 と書ける（拡張関数）`() = assertEquals("Fizz", 3.FizzBuzz変換())
}
