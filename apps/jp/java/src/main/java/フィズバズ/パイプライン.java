package フィズバズ;

import static フィズバズ.日本語文.文;

import java.util.List;
import java.util.stream.IntStream;

/** 題材 C: 不変データとパイプライン処理。 */
public final class パイプライン {

    private パイプライン() {
    }

    /** 文字列を角括弧で囲む。 */
    public static String 装飾(String 文字列) {
        return "[" + 文字列 + "]";
    }

    /** なでしこ3 の「NをFizzBuzz変換して装飾して戻す」を語順どおりに書く。 */
    public static String FizzBuzz装飾(int 数) {
        return 文(数).を(FizzBuzz::FizzBuzz変換).して(パイプライン::装飾).戻す();
    }

    /** 1 から 数 までを FizzBuzz 装飾した配列を作る。 */
    public static List<String> パイプライン処理(int 数) {
        return IntStream.rangeClosed(1, 数).mapToObj(パイプライン::FizzBuzz装飾).toList();
    }
}
