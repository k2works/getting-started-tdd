package fizzbuzz

import org.scalatest.funsuite.AnyFunSuite
import scala.util.Success

class FizzBuzzSpec extends AnyFunSuite:
  test("1 を渡すと文字列 1 を返す") {
    assert(FizzBuzz.generate(1) === "1")
  }

  test("2 を渡すと文字列 2 を返す") {
    assert(FizzBuzz.generate(2) === "2")
  }

  test("3 の倍数を渡すと Fizz を返す") {
    assert(FizzBuzz.generate(3) === "Fizz")
  }

  test("5 の倍数を渡すと Buzz を返す") {
    assert(FizzBuzz.generate(5) === "Buzz")
  }

  test("15 の倍数を渡すと FizzBuzz を返す") {
    assert(FizzBuzz.generate(15) === "FizzBuzz")
  }

  test("1 から 100 までのリストを生成する") {
    val result = FizzBuzz.generateList(100)
    assert(result.length === 100)
    assert(result.head === "1")
    assert(result(2) === "Fizz")
    assert(result(4) === "Buzz")
    assert(result(14) === "FizzBuzz")
  }

  test("generateWith: カスタムルールで生成する") {
    val customRule: Int => String = n => if n % 2 == 0 then "Even" else "Odd"
    assert(FizzBuzz.generateWith(customRule)(2) === "Even")
    assert(FizzBuzz.generateWith(customRule)(3) === "Odd")
  }

  test("compose: 2 つの関数を合成する") {
    val addBrackets: String => String = s => s"[$s]"
    val toUpper: String => String = _.toUpperCase
    val combined = FizzBuzz.compose(addBrackets, toUpper)
    assert(combined("Fizz") === "[FIZZ]")
  }

  test("transform: 各要素を変換する") {
    val result = FizzBuzz.transform(List("Fizz", "Buzz"), _.toUpperCase)
    assert(result === List("FIZZ", "BUZZ"))
  }

  test("filter: 条件に一致する要素だけ残す") {
    val result = FizzBuzz.filter(List("1", "Fizz", "2", "Buzz"), _.forall(_.isLetter))
    assert(result === List("Fizz", "Buzz"))
  }

  test("lazyList: 遅延リストから最初の 5 要素を取得する") {
    val result = FizzBuzz.lazyList.take(5).toList
    assert(result === List("1", "2", "Fizz", "4", "Buzz"))
  }

  test("lazyList: 遅延リストから 15 番目の要素を取得する") {
    assert(FizzBuzz.lazyList(14) === "FizzBuzz")
  }

  test("safeGenerate: 正の整数なら Some を返す") {
    assert(FizzBuzz.safeGenerate(3) === Some("Fizz"))
  }

  test("safeGenerate: 0 以下なら None を返す") {
    assert(FizzBuzz.safeGenerate(0) === None)
  }

  test("generateEither: 正の整数なら Right を返す") {
    assert(FizzBuzz.generateEither(5) === Right("Buzz"))
  }

  test("generateEither: 0 以下なら Left を返す") {
    assert(FizzBuzz.generateEither(0) === Left("正の整数が必要です: 0"))
  }

  test("parseNumber: 数値文字列なら Success を返す") {
    assert(FizzBuzz.parseNumber("42") === Success(42))
  }

  test("parseNumber: 数値でなければ Failure を返す") {
    assert(FizzBuzz.parseNumber("Fizz").isFailure)
  }
