from lib.application.fizz_buzz_command import FizzBuzzCommand
from lib.domain.model.fizz_buzz_value import FizzBuzzValue
from lib.domain.type.fizz_buzz_type import FizzBuzzType


class FizzBuzzValueCommand(FizzBuzzCommand):
    """単一値の FizzBuzz を実行するコマンド。"""

    def __init__(self, type_: FizzBuzzType, number: int) -> None:
        self._type = type_
        self._number = number

    def execute(self) -> FizzBuzzValue:
        return self._type.generate(self._number)
