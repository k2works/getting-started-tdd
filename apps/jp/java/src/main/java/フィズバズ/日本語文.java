package フィズバズ;

import java.util.function.Function;

/**
 * 語順を再現するための包み。{@code 文(3).を(FizzBuzz::FizzBuzz変換).戻す()} のように
 * 目的語を先に置き、助詞に相当するメソッドで動詞（関数）をつなぐ。
 *
 * @param <T> 包んでいる値の型
 * @param 値 包んでいる値
 */
public record 日本語文<T>(T 値) {

    /** 目的語を置いて文を始める。 */
    public static <T> 日本語文<T> 文(T 値) {
        return new 日本語文<>(値);
    }

    /** 「〜を（動詞）」: 値に動詞を適用する。 */
    public <R> 日本語文<R> を(Function<? super T, ? extends R> 動詞) {
        return new 日本語文<>(動詞.apply(値));
    }

    /** 「〜して（動詞）」: 続けて動詞を適用する。 */
    public <R> 日本語文<R> して(Function<? super T, ? extends R> 動詞) {
        return を(動詞);
    }

    /** 「戻す」: 値を取り出す。 */
    public T 戻す() {
        return 値;
    }
}
