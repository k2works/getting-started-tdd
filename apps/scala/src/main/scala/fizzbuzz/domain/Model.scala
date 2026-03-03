package fizzbuzz.domain

case class FizzBuzzValue(number: Int, value: String):
  require(number > 0, s"数値は正の整数でなければなりません: $number")

  override def toString: String = value

case class FizzBuzzList(values: List[FizzBuzzValue]):
  require(values.nonEmpty, "リストは空であってはなりません")

  def toStringList: List[String] = values.map(_.value)

  def count: Int = values.length

object FizzBuzzList:
  def create(count: Int, fizzBuzzType: FizzBuzzType): FizzBuzzList =
    val values = (1 to count).map { n =>
      FizzBuzzValue(n, fizzBuzzType.generate(n))
    }.toList
    FizzBuzzList(values)
