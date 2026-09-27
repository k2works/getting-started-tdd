package フィズバズ;

import static org.junit.jupiter.api.Assertions.assertEquals;
import static フィズバズ.FizzBuzz.FizzBuzz変換;
import static フィズバズ.FizzBuzz.FizzBuzz配列作成;
import static フィズバズ.日本語文.文;

import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;

@DisplayName("FizzBuzz 変換")
class FizzBuzzテスト {

    @Test
    @DisplayName("3を渡したらFizzを返す")
    void 三を渡したらFizzを返す() {
        assertEquals("Fizz", FizzBuzz変換(3));
    }

    @Test
    @DisplayName("5を渡したらBuzzを返す")
    void 五を渡したらBuzzを返す() {
        assertEquals("Buzz", FizzBuzz変換(5));
    }

    @Test
    @DisplayName("15を渡したらFizzBuzzを返す")
    void 十五を渡したらFizzBuzzを返す() {
        assertEquals("FizzBuzz", FizzBuzz変換(15));
    }

    @Test
    @DisplayName("1を渡したら文字列1を返す")
    void 一を渡したら文字列1を返す() {
        assertEquals("1", FizzBuzz変換(1));
    }

    @Test
    @DisplayName("2を渡したら文字列2を返す")
    void 二を渡したら文字列2を返す() {
        assertEquals("2", FizzBuzz変換(2));
    }

    @Test
    @DisplayName("15まで作ると15件になる")
    void 十五まで作ると15件になる() {
        assertEquals(15, FizzBuzz配列作成(15).size());
    }

    @Test
    @DisplayName("15まで作った配列の並び")
    void 十五まで作った配列の並び() {
        assertEquals("1,2,Fizz,4,Buzz,Fizz,7,8,Fizz,Buzz,11,Fizz,13,14,FizzBuzz",
                String.join(",", FizzBuzz配列作成(15)));
    }

    @Test
    @DisplayName("3を FizzBuzz変換（語順の再現）")
    void 語順を再現して三をFizzBuzz変換する() {
        assertEquals("Fizz", 文(3).を(FizzBuzz::FizzBuzz変換).戻す());
    }
}
