package fizzbuzz

import fizzbuzz.domain.{FizzBuzzList, FizzBuzzType}
import org.scalatest.funsuite.AnyFunSuite

class ListSpec extends AnyFunSuite:
  test("FizzBuzzList: 1 から 15 までの結果を保持する") {
    val result = FizzBuzzList.create(15, FizzBuzzType.Type01)
    assert(result.count === 15)
    assert(result.toStringList.head === "1")
    assert(result.toStringList(14) === "FizzBuzz")
  }

  test("FizzBuzzList: 空リストでは例外が発生する") {
    assertThrows[IllegalArgumentException] {
      FizzBuzzList(Nil)
    }
  }
