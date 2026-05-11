package fizzbuzz

import fizzbuzz.domain.{FizzBuzzList, FizzBuzzType}

object FizzBuzz:
  def generate(number: Int): String = FizzBuzzType.Type01.generate(number)

  def generateList(count: Int): List[String] =
    FizzBuzzList.create(count, FizzBuzzType.Type01).toStringList
