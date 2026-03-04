package fizzbuzz.domain

import org.scalatest.funsuite.AnyFunSuite

class TypeSpec extends AnyFunSuite:
  // Type01: 通常の FizzBuzz
  test("Type01: 1 を渡すと 1 を返す") {
    assert(FizzBuzzType.Type01.generate(1) === "1")
  }

  test("Type01: 3 の倍数で Fizz を返す") {
    assert(FizzBuzzType.Type01.generate(3) === "Fizz")
  }

  test("Type01: 5 の倍数で Buzz を返す") {
    assert(FizzBuzzType.Type01.generate(5) === "Buzz")
  }

  test("Type01: 15 の倍数で FizzBuzz を返す") {
    assert(FizzBuzzType.Type01.generate(15) === "FizzBuzz")
  }

  // Type02: 数値のみ
  test("Type02: 3 を渡すと 3 を返す") {
    assert(FizzBuzzType.Type02.generate(3) === "3")
  }

  test("Type02: 15 を渡すと 15 を返す") {
    assert(FizzBuzzType.Type02.generate(15) === "15")
  }

  // Type03: FizzBuzz のみ
  test("Type03: 1 を渡すと 1 を返す") {
    assert(FizzBuzzType.Type03.generate(1) === "1")
  }

  test("Type03: 3 を渡すと 3 を返す") {
    assert(FizzBuzzType.Type03.generate(3) === "3")
  }

  test("Type03: 15 の倍数で FizzBuzz を返す") {
    assert(FizzBuzzType.Type03.generate(15) === "FizzBuzz")
  }

  // ファクトリメソッド
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
