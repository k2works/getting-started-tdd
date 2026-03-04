package fizzbuzz

import fizzbuzz.domain.*

object FizzBuzz:
  // 基本 API
  def generate(number: Int): String =
    number match
      case n if n % 15 == 0 => "FizzBuzz"
      case n if n % 3 == 0  => "Fizz"
      case n if n % 5 == 0  => "Buzz"
      case n                => n.toString

  def generateList(count: Int): List[String] =
    (1 to count).map(generate).toList

  // 高階関数
  def generateWith(rule: Int => String)(number: Int): String =
    rule(number)

  def transform(values: List[String], f: String => String): List[String] =
    values.map(f)

  def filter(values: List[String], predicate: String => Boolean): List[String] =
    values.filter(predicate)

  // 関数合成
  def compose(f: String => String, g: String => String): String => String =
    f.compose(g)

  // Option による安全な処理
  def safeGenerate(number: Int): Option[String] =
    if number > 0 then Some(generate(number))
    else None

  // Either によるエラーハンドリング
  def generateEither(number: Int): Either[String, String] =
    if number > 0 then Right(generate(number))
    else Left(s"正の整数が必要です: $number")

  // 遅延評価
  def lazyList: LazyList[String] =
    LazyList.from(1).map(generate)

  def main(args: Array[String]): Unit =
    generateList(100).foreach(println)
