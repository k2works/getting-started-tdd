package フィズバズ

/** 文字列を角括弧で囲む。 */
def 装飾(文字列: String): String = s"[$文字列]"

/** なでしこ3 の「NをFizzBuzz変換して装飾して戻す」を中置の拡張メソッドで語順どおりに書く。 */
def FizzBuzz装飾(数: Int): String = 数 を FizzBuzz変換 して 装飾

/** 1 から数までを FizzBuzz 装飾したリストを作る。 */
def パイプライン処理(数: Int): List[String] = (1 to 数).map(FizzBuzz装飾).toList
