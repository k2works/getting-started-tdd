package fizzbuzz

/**
 * 数値と変換結果をまとめた値オブジェクト。
 */
data class FizzBuzzValue(val number: Int, val value: String) {
    companion object {
        /** タイプに従って数 [n] の値オブジェクトを生成する。 */
        fun create(type: FizzBuzzType, n: Int): FizzBuzzValue =
            FizzBuzzValue(n, type.generate(n))
    }
}
