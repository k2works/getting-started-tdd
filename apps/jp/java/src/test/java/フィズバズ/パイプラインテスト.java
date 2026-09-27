package フィズバズ;

import static org.junit.jupiter.api.Assertions.assertEquals;
import static フィズバズ.パイプライン.パイプライン処理;
import static フィズバズ.パイプライン.装飾;

import java.util.List;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;

@DisplayName("パイプライン")
class パイプラインテスト {

    @Test
    @DisplayName("装飾すると角括弧で囲む")
    void 装飾すると角括弧で囲む() {
        assertEquals("[Fizz]", 装飾("Fizz"));
    }

    @Test
    @DisplayName("5までのパイプライン処理")
    void 五までのパイプライン処理() {
        assertEquals(List.of("[1]", "[2]", "[Fizz]", "[4]", "[Buzz]"), パイプライン処理(5));
    }
}
