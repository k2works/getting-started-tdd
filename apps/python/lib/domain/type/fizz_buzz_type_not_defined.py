from lib.domain.model.fizz_buzz_value import FizzBuzzValue
from lib.domain.type.fizz_buzz_type import FizzBuzzType


class FizzBuzzTypeNotDefined(FizzBuzzType):
    """未定義タイプ: Null Object パターン。"""

    def generate(self, number: int) -> FizzBuzzValue:
        return FizzBuzzValue(number, "")
