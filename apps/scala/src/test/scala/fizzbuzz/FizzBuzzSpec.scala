package fizzbuzz

import org.scalatest.funsuite.AnyFunSuite

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
