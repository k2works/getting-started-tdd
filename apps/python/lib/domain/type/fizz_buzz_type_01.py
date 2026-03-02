from lib.domain.model.fizz_buzz_value import FizzBuzzValue
from lib.domain.type.fizz_buzz_type import FizzBuzzType


class FizzBuzzType01(FizzBuzzType):
    """タイプ 1: 通常の FizzBuzz。"""

    def generate(self, number: int) -> FizzBuzzValue:
        if self._is_fizz_buzz(number):
            return FizzBuzzValue(number, "FizzBuzz")
        if self._is_fizz(number):
            return FizzBuzzValue(number, "Fizz")
        if self._is_buzz(number):
            return FizzBuzzValue(number, "Buzz")
        return FizzBuzzValue(number, str(number))
