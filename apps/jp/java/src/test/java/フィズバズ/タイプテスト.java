package フィズバズ;

import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.junit.jupiter.api.Assertions.assertThrows;
import static フィズバズ.タイプ.タイプ変換;
import static フィズバズ.タイプ.タイプ生成;

import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;

@DisplayName("タイプ生成")
class タイプテスト {

    @Test
    @DisplayName("タイプ1は通常の変換をする")
    void タイプ1は通常の変換をする() {
        タイプ 通常 = タイプ生成(1);
        assertEquals("Fizz", タイプ変換(通常, 3));
        assertEquals("通常", 通常.名前());
    }

    @Test
    @DisplayName("タイプ2は数字だけを返す")
    void タイプ2は数字だけを返す() {
        タイプ 数字 = タイプ生成(2);
        assertEquals("3", タイプ変換(数字, 3));
        assertEquals("数字限定", 数字.名前());
    }

    @Test
    @DisplayName("タイプ3は15の倍数だけFizzBuzzを返す")
    void タイプ3は15の倍数だけFizzBuzzを返す() {
        assertEquals("FizzBuzz", タイプ変換(タイプ生成(3), 15));
    }

    @Test
    @DisplayName("タイプ3は3の倍数を数字で返す")
    void タイプ3は3の倍数を数字で返す() {
        assertEquals("3", タイプ変換(タイプ生成(3), 3));
    }

    @Test
    @DisplayName("存在しないタイプはエラーになる")
    void 存在しないタイプはエラーになる() {
        IllegalArgumentException 例外 =
                assertThrows(IllegalArgumentException.class, () -> タイプ生成(4));
        assertEquals("該当するタイプは存在しません: 4", 例外.getMessage());
    }

    @Test
    @DisplayName("列挙子を日本語で直接参照できる")
    void 列挙子を日本語で直接参照できる() {
        assertEquals(タイプ.FizzBuzz限定, タイプ生成(3));
    }
}
