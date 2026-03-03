package fizzbuzz

import org.scalatest.funsuite.AnyFunSuite

class FizzBuzzSpec extends AnyFunSuite:
  // 基本テスト
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

  // 高階関数テスト
  test("generateWith: カスタムルールで生成する") {
    val customRule: Int => String = n => if n % 2 == 0 then "Even" else "Odd"
    assert(FizzBuzz.generateWith(customRule)(2) === "Even")
    assert(FizzBuzz.generateWith(customRule)(3) === "Odd")
  }

  test("transform: リストの各要素を変換する") {
    val values = List("1", "Fizz", "Buzz")
    val result = FizzBuzz.transform(values, _.toUpperCase)
    assert(result === List("1", "FIZZ", "BUZZ"))
  }

  test("filter: 条件に合う要素を抽出する") {
    val values = List("1", "2", "Fizz", "4", "Buzz")
    val result = FizzBuzz.filter(values, v => v.forall(_.isDigit))
    assert(result === List("1", "2", "4"))
  }

  // 関数合成テスト
  test("compose: 2 つの関数を合成する") {
    val addBrackets: String => String = s => s"[$s]"
    val toUpper: String => String = _.toUpperCase
    val combined = FizzBuzz.compose(addBrackets, toUpper)
    assert(combined("Fizz") === "[FIZZ]")
  }

  // Option テスト
  test("safeGenerate: 正の整数で Some を返す") {
    assert(FizzBuzz.safeGenerate(3) === Some("Fizz"))
  }

  test("safeGenerate: 0 以下で None を返す") {
    assert(FizzBuzz.safeGenerate(0) === None)
    assert(FizzBuzz.safeGenerate(-1) === None)
  }

  // Either テスト
  test("generateEither: 正の整数で Right を返す") {
    assert(FizzBuzz.generateEither(3) === Right("Fizz"))
  }

  test("generateEither: 0 以下で Left を返す") {
    assert(FizzBuzz.generateEither(0).isLeft)
  }

  // LazyList テスト
  test("lazyList: 遅延リストから最初の 5 要素を取得する") {
    val result = FizzBuzz.lazyList.take(5).toList
    assert(result === List("1", "2", "Fizz", "4", "Buzz"))
  }

  test("lazyList: 遅延リストから 15 番目の要素を取得する") {
    assert(FizzBuzz.lazyList(14) === "FizzBuzz")
  }
