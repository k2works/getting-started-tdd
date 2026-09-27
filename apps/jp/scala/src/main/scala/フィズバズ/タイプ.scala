package フィズバズ

/** 題材 B: タイプ別の変換。列挙子の名前がそのままタイプの名前になる。 */
enum タイプ(val 変換: Int => String):
  case 通常 extends タイプ(FizzBuzz変換)
  case 数字限定 extends タイプ(_.toString)
  case FizzBuzz限定 extends タイプ(数 => if 数 % フィズバズ == 0 then "FizzBuzz" else 数.toString)

  def 名前: String = toString

/** 番号からタイプを生成する。 */
def タイプ生成(番号: Int): タイプ =
  タイプ.values.lift(番号 - 1).getOrElse(throw IllegalArgumentException(s"該当するタイプは存在しません: $番号"))

/** タイプの変換を数に適用する。 */
def タイプ変換(タイプ: タイプ, 数: Int): String = タイプ.変換(数)
