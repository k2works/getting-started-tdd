from lib.domain.model.fizz_buzz_value import FizzBuzzValue
from lib.domain.type.fizz_buzz_type import FizzBuzzType


class FizzBuzzType02(FizzBuzzType):
    """タイプ 2: 数をそのまま文字列で返す。"""

    def generate(self, number: int) -> FizzBuzzValue:
        return FizzBuzzValue(number, str(number))
