package フィズバズ

import kotlin.test.Test
import kotlin.test.assertEquals
import kotlin.test.assertFailsWith

class タイプテスト {
    @Test fun `タイプ1は通常の変換をする`() {
        val 通常 = タイプ生成(1)
        assertEquals("Fizz", タイプ変換(通常, 3))
        assertEquals("通常", 通常.名前)
    }

    @Test fun `タイプ2は数字だけを返す`() {
        val 数字 = タイプ生成(2)
        assertEquals("3", タイプ変換(数字, 3))
        assertEquals("数字限定", 数字.名前)
    }

    @Test fun `タイプ3は15の倍数だけFizzBuzzを返す`() = assertEquals("FizzBuzz", タイプ変換(タイプ生成(3), 15))

    @Test fun `タイプ3は3の倍数を数字で返す`() = assertEquals("3", タイプ変換(タイプ生成(3), 3))

    @Test fun `存在しないタイプはエラーになる`() {
        val 例外 = assertFailsWith<IllegalArgumentException> { タイプ生成(4) }
        assertEquals("該当するタイプは存在しません: 4", 例外.message)
    }

    @Test fun `列挙子を日本語で when に書ける`() {
        val 説明 =
            when (タイプ生成(3)) {
                タイプ.通常 -> "通常"
                タイプ.数字限定 -> "数字だけ"
                タイプ.FizzBuzz限定 -> "15 の倍数だけ"
            }
        assertEquals("15 の倍数だけ", 説明)
    }
}
