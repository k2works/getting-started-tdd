package fizzbuzz

/**
 * エラーハンドリングと型安全性。
 */
object FizzBuzzError {
    /**
     * 正の数のみ受け付ける安全な変換。ゼロ以下は失敗を返す。
     */
    fun safeConvert(n: Int): Result<String> =
        if (n <= 0) Result.failure(IllegalArgumentException("正の数を指定してください: $n"))
        else Result.success(FizzBuzz.convert(n))

    /**
     * null 許容の入力を安全に変換する。null なら null を返す（NPE を型で防ぐ）。
     */
    fun convertOrNull(n: Int?): String? = n?.let(FizzBuzz::convert)
}
