package fizzbuzz

import fizzbuzz.domain.{FizzBuzzList, FizzBuzzType}
import scala.util.Try

object FizzBuzz:
  def generate(number: Int): String = FizzBuzzType.Type01.generate(number)

  def generateWith(rule: Int => String)(number: Int): String =
    rule(number)

  def compose(f: String => String, g: String => String): String => String =
    f.compose(g)

  def transform(values: List[String], f: String => String): List[String] =
    values.map(f)

  def filter(values: List[String], predicate: String => Boolean): List[String] =
    values.filter(predicate)

  def lazyList: LazyList[String] =
    LazyList.from(1).map(generate)

  def safeGenerate(number: Int): Option[String] =
    if number > 0 then Some(generate(number))
    else None

  def generateEither(number: Int): Either[String, String] =
    if number > 0 then Right(generate(number))
    else Left(s"正の整数が必要です: $number")

  def parseNumber(input: String): Try[Int] =
    Try(input.toInt)

  def generateList(count: Int): List[String] =
    FizzBuzzList.create(count, FizzBuzzType.Type01).toStringList
