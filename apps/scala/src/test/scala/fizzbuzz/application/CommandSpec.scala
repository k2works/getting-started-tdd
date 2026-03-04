package fizzbuzz.application

import org.scalatest.funsuite.AnyFunSuite

class CommandSpec extends AnyFunSuite:
  test("FizzBuzzValueCommand: タイプ 1 で 1 を渡すと 1 を返す") {
    val command = FizzBuzzValueCommand(1, 1)
    assert(command.execute() === "1")
  }

  test("FizzBuzzValueCommand: タイプ 1 で 3 を渡すと Fizz を返す") {
    val command = FizzBuzzValueCommand(3, 1)
    assert(command.execute() === "Fizz")
  }

  test("FizzBuzzValueCommand: タイプ 2 で 3 を渡すと 3 を返す") {
    val command = FizzBuzzValueCommand(3, 2)
    assert(command.execute() === "3")
  }

  test("FizzBuzzListCommand: タイプ 1 で 100 件のリストを生成する") {
    val command = FizzBuzzListCommand(100, 1)
    val result = command.execute()
    val lines = result.split("\n")
    assert(lines.length === 100)
    assert(lines.head === "1")
    assert(lines(2) === "Fizz")
    assert(lines(4) === "Buzz")
    assert(lines(14) === "FizzBuzz")
  }

  test("FizzBuzzListCommand: タイプ 2 で数値のみのリストを生成する") {
    val command = FizzBuzzListCommand(5, 2)
    val result = command.execute()
    assert(result === "1\n2\n3\n4\n5")
  }
