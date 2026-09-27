package フィズバズ

private val フィズ = 3
private val バズ = 5
private[フィズバズ] val フィズバズ = 15

/** 題材 A: 数を FizzBuzz の文字列に変換する。 */
def FizzBuzz変換(数: Int): String =
  if 数 % フィズバズ == 0 then "FizzBuzz"
  else if 数 % フィズ == 0 then "Fizz"
  else if 数 % バズ == 0 then "Buzz"
  else 数.toString

/** 1 から数までを FizzBuzz 変換したリストを作る。 */
def FizzBuzz配列作成(数: Int): List[String] = (1 to 数).map(FizzBuzz変換).toList
