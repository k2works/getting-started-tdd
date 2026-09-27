package フィズバズ

/** 題材 B: タイプ別の変換。列挙子の名前がそのままタイプの名前になる。 */
enum class タイプ(
    val 変換: (Int) -> String,
) {
    通常(::FizzBuzz変換),
    数字限定({ 数 -> 数.toString() }),
    FizzBuzz限定({ 数 -> if (数 % フィズバズ == 0) "FizzBuzz" else 数.toString() }),
    ;

    val 名前: String get() = name
}

/** 番号からタイプを生成する。 */
fun タイプ生成(番号: Int): タイプ =
    タイプ.entries.getOrNull(番号 - 1)
        ?: throw IllegalArgumentException("該当するタイプは存在しません: $番号")

/** タイプの変換を数に適用する。 */
fun タイプ変換(
    タイプ: タイプ,
    数: Int,
): String = タイプ.変換(数)
