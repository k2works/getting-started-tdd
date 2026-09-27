package フィズバズ;

import java.util.List;
import java.util.stream.IntStream;

/** 題材 A: FizzBuzz の基本変換。 */
public final class FizzBuzz {

    static final int フィズ = 3;
    static final int バズ = 5;
    static final int フィズバズ = 15;

    private FizzBuzz() {
    }

    /** 数を FizzBuzz の文字列に変換する。 */
    public static String FizzBuzz変換(int 数) {
        if (数 % フィズバズ == 0) {
            return "FizzBuzz";
        }
        if (数 % フィズ == 0) {
            return "Fizz";
        }
        if (数 % バズ == 0) {
            return "Buzz";
        }
        return String.valueOf(数);
    }

    /** 1 から 数 までを FizzBuzz 変換した配列を作る。 */
    public static List<String> FizzBuzz配列作成(int 数) {
        return IntStream.rangeClosed(1, 数).mapToObj(FizzBuzz::FizzBuzz変換).toList();
    }
}
