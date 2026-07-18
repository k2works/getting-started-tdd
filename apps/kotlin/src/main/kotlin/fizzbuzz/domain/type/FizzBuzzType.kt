package fizzbuzz.domain.type

/**
 * FizzBuzz のタイプ（出力の切り替え）を表す列挙型。
 * 各ケースが generate を実装する（State パターン相当）。
 */
enum class FizzBuzzType {
    /** 通常の FizzBuzz。 */
    TYPE_01 {
        override fun generate(n: Int): String = when {
            n % 15 == 0 -> "FizzBuzz"
            n % 3 == 0 -> "Fizz"
            n % 5 == 0 -> "Buzz"
            else -> n.toString()
        }
    },

    /** 数字のみ。 */
    TYPE_02 {
        override fun generate(n: Int): String = n.toString()
    },

    /** Fizz の場合のみ（Buzz なし）。 */
    TYPE_03 {
        override fun generate(n: Int): String = when {
            n % 15 == 0 -> "FizzBuzz"
            n % 3 == 0 -> "Fizz"
            else -> n.toString()
        }
    };

    /** 数 [n] をタイプに従って文字列へ変換する。 */
    abstract fun generate(n: Int): String

    companion object {
        /**
         * タイプ番号から FizzBuzzType を生成する。未定義の番号は失敗を返す。
         */
        fun create(no: Int): Result<FizzBuzzType> = when (no) {
            1 -> Result.success(TYPE_01)
            2 -> Result.success(TYPE_02)
            3 -> Result.success(TYPE_03)
            else -> Result.failure(IllegalArgumentException("該当するタイプは存在しません: $no"))
        }
    }
}
