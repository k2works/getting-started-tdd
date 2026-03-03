package fizzbuzz

object FizzBuzz:
  def generate(number: Int): String =
    number match
      case n if n % 15 == 0 => "FizzBuzz"
      case n if n % 3 == 0  => "Fizz"
      case n if n % 5 == 0  => "Buzz"
      case n                => n.toString

  def generateList(count: Int): List[String] =
    (1 to count).map(generate).toList

  def main(args: Array[String]): Unit =
    generateList(100).foreach(println)
