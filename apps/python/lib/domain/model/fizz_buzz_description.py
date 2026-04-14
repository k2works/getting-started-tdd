from lib.domain.model.fizz_buzz_value import FizzBuzzValue


def describe(value: FizzBuzzValue) -> str:
    match value.value:
        case "Fizz":
            return f"{value.number} は 3 の倍数"
        case "Buzz":
            return f"{value.number} は 5 の倍数"
        case "FizzBuzz":
            return f"{value.number} は 15 の倍数"
        case _:
            return f"{value.number} はそのまま"
