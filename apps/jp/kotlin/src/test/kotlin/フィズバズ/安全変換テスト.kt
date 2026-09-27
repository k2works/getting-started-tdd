package フィズバズ

import kotlin.test.Test
import kotlin.test.assertEquals

class 安全変換テスト {
    @Test fun `正の数は成功になる`() = assertEquals(変換結果.成功("Fizz"), 安全変換(3))

    @Test fun `0は失敗になる`() = assertEquals(変換結果.失敗("正の数を指定してください: 0"), 安全変換(0))

    @Test fun `結果は when で取り出せる`() {
        val 表示 =
            when (val 結果 = 安全変換(0)) {
                is 変換結果.成功 -> "成功 ${結果.値}"
                is 変換結果.失敗 -> "失敗 ${結果.エラー}"
            }
        assertEquals("失敗 正の数を指定してください: 0", 表示)
    }
}
