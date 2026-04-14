from lib.application.fizz_buzz_command import FizzBuzzCommand
from lib.domain.model.fizz_buzz_list import FizzBuzzList
from lib.domain.type.fizz_buzz_type import FizzBuzzType


class FizzBuzzListCommand(FizzBuzzCommand):
    MAX_NUMBER: int = 100

    def __init__(self, type_: FizzBuzzType) -> None:
        self._type = type_

    def execute(self) -> FizzBuzzList:
        values = [self._type.generate(i) for i in range(1, self.MAX_NUMBER + 1)]
        return FizzBuzzList(values)
