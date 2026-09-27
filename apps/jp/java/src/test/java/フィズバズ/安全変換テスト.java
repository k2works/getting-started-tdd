package フィズバズ;

import static org.junit.jupiter.api.Assertions.assertEquals;
import static フィズバズ.エラー処理.安全変換;

import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;

@DisplayName("安全変換")
class 安全変換テスト {

    @Test
    @DisplayName("正の数は成功になる")
    void 正の数は成功になる() {
        assertEquals(new 変換結果.成功("Fizz"), 安全変換(3));
    }

    @Test
    @DisplayName("0は失敗になる")
    void 零は失敗になる() {
        assertEquals(new 変換結果.失敗("正の数を指定してください: 0"), 安全変換(0));
    }

    @Test
    @DisplayName("結果はパターンマッチで取り出せる")
    void 結果はパターンマッチで取り出せる() {
        String 表示 = switch (安全変換(0)) {
            case 変換結果.成功(String 値) -> "成功: " + 値;
            case 変換結果.失敗(String エラー) -> "失敗: " + エラー;
        };
        assertEquals("失敗: 正の数を指定してください: 0", 表示);
    }
}
