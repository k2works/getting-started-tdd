package fizzbuzz

import fizzbuzz.domain.FizzBuzzType
import org.scalatest.funsuite.AnyFunSuite

class TypeSpec extends AnyFunSuite:
  test("Type01: 3 の倍数で Fizz を返す") {
    assert(FizzBuzzType.Type01.generate(3) === "Fizz")
  }

  test("Type02: 15 を渡すと 15 を返す") {
    assert(FizzBuzzType.Type02.generate(15) === "15")
  }

  test("Type03: 15 の倍数で FizzBuzz を返す") {
    assert(FizzBuzzType.Type03.generate(15) === "FizzBuzz")
  }

  test("create: タイプ 1 を生成できる") {
    assert(FizzBuzzType.create(1) === FizzBuzzType.Type01)
  }

  test("create: タイプ 2 を生成できる") {
    assert(FizzBuzzType.create(2) === FizzBuzzType.Type02)
  }

  test("create: タイプ 3 を生成できる") {
    assert(FizzBuzzType.create(3) === FizzBuzzType.Type03)
  }

  test("create: 未定義のタイプで例外が発生する") {
    assertThrows[IllegalArgumentException] {
      FizzBuzzType.create(4)
    }
  }
