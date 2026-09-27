package フィズバズ

private const val フィズ = 3
private const val バズ = 5
internal const val フィズバズ = 15

/** 題材 A: 数を FizzBuzz の文字列に変換する。 */
fun FizzBuzz変換(数: Int): String =
    when {
        数 % フィズバズ == 0 -> "FizzBuzz"
        数 % フィズ == 0 -> "Fizz"
        数 % バズ == 0 -> "Buzz"
        else -> 数.toString()
    }

/** 1 から数までを FizzBuzz 変換したリストを作る。 */
fun FizzBuzz配列作成(数: Int): List<String> = (1..数).map(::FizzBuzz変換)

/**
 * 拡張関数版: `3.FizzBuzz変換()`。
 * トップレベルの FizzBuzz変換(Int) と JVM シグネチャが衝突するため JVM 上の名前だけ変える。
 */
@JvmName("FizzBuzz変換拡張")
fun Int.FizzBuzz変換(): String = FizzBuzz変換(this)
