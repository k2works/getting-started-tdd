from lib.domain.model.fizz_buzz_value import FizzBuzzValue
from lib.domain.type.fizz_buzz_type import FizzBuzzType


class FizzBuzzType03(FizzBuzzType):
    """タイプ 3: FizzBuzz のみ、それ以外は数を返す。"""

    def generate(self, number: int) -> FizzBuzzValue:
        if self._is_fizz_buzz(number):
            return FizzBuzzValue(number, "FizzBuzz")
        return FizzBuzzValue(number, str(number))
