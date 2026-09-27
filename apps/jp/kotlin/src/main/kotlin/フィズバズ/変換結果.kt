package フィズバズ

/** 題材 D: 変換結果（成功または失敗）。 */
sealed interface 変換結果 {
    data class 成功(
        val 値: String,
    ) : 変換結果

    data class 失敗(
        val エラー: String,
    ) : 変換結果
}

/** 0 以下なら失敗、それ以外は FizzBuzz 変換の結果を成功として返す。 */
fun 安全変換(数: Int): 変換結果 =
    if (数 <= 0) {
        変換結果.失敗("正の数を指定してください: $数")
    } else {
        変換結果.成功(FizzBuzz変換(数))
    }
