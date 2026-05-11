package fizzbuzz

import fizzbuzz.application.{FizzBuzzListCommand, FizzBuzzValueCommand}
import org.scalatest.funsuite.AnyFunSuite

class CommandSpec extends AnyFunSuite:
  test("FizzBuzzValueCommand: 単一値を返す") {
    val command = FizzBuzzValueCommand(3, 1)
    assert(command.execute() === "Fizz")
  }

  test("FizzBuzzListCommand: 複数値を改行区切りで返す") {
    val command = FizzBuzzListCommand(5, 1)
    assert(command.execute() === "1\n2\nFizz\n4\nBuzz")
  }
