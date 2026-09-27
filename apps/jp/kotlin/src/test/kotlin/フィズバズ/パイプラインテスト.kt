package フィズバズ

import kotlin.test.Test
import kotlin.test.assertEquals

class パイプラインテスト {
    @Test fun `装飾すると角括弧で囲む`() = assertEquals("[Fizz]", 装飾("Fizz"))

    @Test fun `5までのパイプライン処理`() = assertEquals(listOf("[1]", "[2]", "[Fizz]", "[4]", "[Buzz]"), パイプライン処理(5))

    @Test fun `15を FizzBuzz変換 して 装飾 する`() = assertEquals("[FizzBuzz]", FizzBuzz装飾(15))
}
