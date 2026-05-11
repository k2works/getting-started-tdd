package fizzbuzz.application

import fizzbuzz.domain.{FizzBuzzList, FizzBuzzType, FizzBuzzValue}

trait FizzBuzzCommand:
  def execute(): String

case class FizzBuzzValueCommand(number: Int, typeNumber: Int) extends FizzBuzzCommand:
  def execute(): String =
    val fizzBuzzType = FizzBuzzType.create(typeNumber)
    val value = FizzBuzzValue(number, fizzBuzzType.generate(number))
    value.toString

case class FizzBuzzListCommand(count: Int, typeNumber: Int) extends FizzBuzzCommand:
  def execute(): String =
    val fizzBuzzType = FizzBuzzType.create(typeNumber)
    FizzBuzzList.create(count, fizzBuzzType).toStringList.mkString("\n")
