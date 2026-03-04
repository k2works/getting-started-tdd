package fizzbuzz.application

import fizzbuzz.domain.*

trait FizzBuzzCommand:
  def execute(): String

class FizzBuzzValueCommand(number: Int, typeNumber: Int) extends FizzBuzzCommand:
  def execute(): String =
    val fizzBuzzType = FizzBuzzType.create(typeNumber)
    val value = FizzBuzzValue(number, fizzBuzzType.generate(number))
    value.toString

class FizzBuzzListCommand(count: Int, typeNumber: Int) extends FizzBuzzCommand:
  def execute(): String =
    val fizzBuzzType = FizzBuzzType.create(typeNumber)
    val list = FizzBuzzList.create(count, fizzBuzzType)
    list.toStringList.mkString("\n")
