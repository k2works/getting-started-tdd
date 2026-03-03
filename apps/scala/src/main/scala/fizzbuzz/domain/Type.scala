package fizzbuzz.domain

sealed trait FizzBuzzType:
  def generate(number: Int): String

object FizzBuzzType:
  case object Type01 extends FizzBuzzType:
    def generate(number: Int): String =
      number match
        case n if n % 15 == 0 => "FizzBuzz"
        case n if n % 3 == 0  => "Fizz"
        case n if n % 5 == 0  => "Buzz"
        case n                => n.toString

  case object Type02 extends FizzBuzzType:
    def generate(number: Int): String = number.toString

  case object Type03 extends FizzBuzzType:
    def generate(number: Int): String =
      number match
        case n if n % 15 == 0 => "FizzBuzz"
        case n                => n.toString

  def create(typeNumber: Int): FizzBuzzType =
    typeNumber match
      case 1 => Type01
      case 2 => Type02
      case 3 => Type03
      case _ => throw IllegalArgumentException(s"未定義のタイプ: $typeNumber")
