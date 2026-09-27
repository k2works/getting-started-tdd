package フィズバズ

import org.scalatest.funsuite.AnyFunSuite

class パイプラインテスト extends AnyFunSuite:
  test("装飾すると角括弧で囲む") {
    assert(装飾("Fizz") === "[Fizz]")
  }

  test("5までのパイプライン処理") {
    assert(パイプライン処理(5) === List("[1]", "[2]", "[Fizz]", "[4]", "[Buzz]"))
  }

  test("15 を FizzBuzz変換 して 装飾 する") {
    assert(FizzBuzz装飾(15) === "[FizzBuzz]")
  }
