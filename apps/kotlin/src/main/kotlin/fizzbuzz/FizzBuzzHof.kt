package fizzbuzz

/**
 * 高階関数による FizzBuzz の一般化。
 */
object FizzBuzzHof {
    /** 変換ルールを関数として受け取り、数 [n] を変換する。 */
    fun generateWith(rule: (Int) -> String, n: Int): String = rule(n)

    /** 標準の FizzBuzz ルール。 */
    fun defaultRule(n: Int): String = when {
        n % 15 == 0 -> "FizzBuzz"
        n % 3 == 0 -> "Fizz"
        n % 5 == 0 -> "Buzz"
        else -> n.toString()
    }

    /** 1 から [n] までのリストに変換関数を適用する。 */
    fun transform(rule: (Int) -> String, n: Int): List<String> = (1..n).map(rule)

    /** リストを述語で絞り込む。 */
    fun filterList(pred: (String) -> Boolean, xs: List<String>): List<String> = xs.filter(pred)
}
