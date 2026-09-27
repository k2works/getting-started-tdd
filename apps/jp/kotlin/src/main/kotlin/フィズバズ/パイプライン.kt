package フィズバズ

/** 文字列を角括弧で囲む。 */
fun 装飾(文字列: String): String = "[$文字列]"

/** なでしこ3 の「NをFizzBuzz変換して装飾して戻す」を中置関数で語順どおりに書く。 */
fun FizzBuzz装飾(数: Int): String = 数 を ::FizzBuzz変換 して ::装飾

/** 1 から数までを FizzBuzz 装飾したリストを作る。 */
fun パイプライン処理(数: Int): List<String> = (1..数).map(::FizzBuzz装飾)
