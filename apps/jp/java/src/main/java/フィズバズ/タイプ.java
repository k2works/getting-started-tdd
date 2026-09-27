package フィズバズ;

import java.util.function.IntFunction;

/** 題材 B: タイプ別の変換。列挙子の名前がそのままタイプの名前になる。 */
public enum タイプ {
    通常(FizzBuzz::FizzBuzz変換),
    数字限定(String::valueOf),
    FizzBuzz限定(タイプ::FizzBuzz限定変換);

    private static final int 通常の番号 = 1;
    private static final int 数字限定の番号 = 2;
    private static final int FizzBuzz限定の番号 = 3;

    private final IntFunction<String> 変換;

    タイプ(IntFunction<String> 変換) {
        this.変換 = 変換;
    }

    /** タイプの名前（列挙子名）。 */
    public String 名前() {
        return name();
    }

    /** 番号からタイプを生成する。 */
    public static タイプ タイプ生成(int 番号) {
        return switch (番号) {
            case 通常の番号 -> 通常;
            case 数字限定の番号 -> 数字限定;
            case FizzBuzz限定の番号 -> FizzBuzz限定;
            default -> throw new IllegalArgumentException("該当するタイプは存在しません: " + 番号);
        };
    }

    /** タイプの変換を数に適用する。 */
    public static String タイプ変換(タイプ タイプ, int 数) {
        return タイプ.変換.apply(数);
    }

    private static String FizzBuzz限定変換(int 数) {
        return 数 % FizzBuzz.フィズバズ == 0 ? "FizzBuzz" : String.valueOf(数);
    }
}
