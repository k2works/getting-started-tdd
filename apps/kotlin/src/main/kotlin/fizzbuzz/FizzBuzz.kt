package fizzbuzz

/**
 * FizzBuzz を解くオブジェクト。
 */
object FizzBuzz {
    /**
     * 数 [n] を FizzBuzz の規則に従って文字列に変換する。
     */
    fun convert(n: Int): String = when {
        n % 15 == 0 -> "FizzBuzz"
        n % 3 == 0 -> "Fizz"
        n % 5 == 0 -> "Buzz"
        else -> n.toString()
    }

    /**
     * 1 から [n] までの FizzBuzz の結果をリストとして返す。
     */
    fun generateList(n: Int): List<String> = (1..n).map(::convert)
}
