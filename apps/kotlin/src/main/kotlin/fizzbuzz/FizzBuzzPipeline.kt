package fizzbuzz

/**
 * 関数合成と不変データのパイプライン処理。
 */
object FizzBuzzPipeline {
    /** 2 つの関数を合成する（f を適用してから g を適用）。 */
    fun <A, B, C> compose(f: (A) -> B, g: (B) -> C): (A) -> C = { x -> g(f(x)) }

    /** 数を FizzBuzz 文字列に変換する。 */
    fun convert(n: Int): String = FizzBuzz.convert(n)

    /** 文字列を括弧で装飾する。 */
    fun decorate(s: String): String = "[$s]"

    /** convert と decorate を合成した変換。 */
    fun convertAndDecorate(n: Int): String = compose(::convert, ::decorate)(n)

    /**
     * パイプラインで 1..n を変換・装飾する。
     * Sequence による遅延評価。元のデータは変更しない。
     */
    fun process(n: Int): List<String> =
        (1..n).asSequence()
            .map(::convert)
            .map(::decorate)
            .toList()
}
