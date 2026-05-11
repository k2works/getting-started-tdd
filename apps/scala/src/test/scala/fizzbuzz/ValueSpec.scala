package fizzbuzz

import fizzbuzz.domain.FizzBuzzValue
import org.scalatest.funsuite.AnyFunSuite

class ValueSpec extends AnyFunSuite:
  test("FizzBuzzValue: 値を文字列として返す") {
    assert(FizzBuzzValue(3, "Fizz").toString === "Fizz")
  }

  test("FizzBuzzValue: 0 以下では例外が発生する") {
    assertThrows[IllegalArgumentException] {
      FizzBuzzValue(0, "0")
    }
  }
