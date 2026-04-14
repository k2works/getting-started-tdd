from lib.application.fizz_buzz_list_command import FizzBuzzListCommand
from lib.application.fizz_buzz_value_command import FizzBuzzValueCommand
from lib.domain.type.fizz_buzz_type import FizzBuzzType


class FizzBuzz:
    def __init__(self, type_: FizzBuzzType) -> None:
        self._type = type_

    @property
    def type(self) -> FizzBuzzType:
        return self._type

    def generate(self, number: int) -> str:
        return FizzBuzzValueCommand(self._type, number).execute().value

    def generate_list(self, count: int) -> list[str]:
        result = FizzBuzzListCommand(self._type).execute()
        return [result.get(i).value for i in range(count)]

    def print_fizzbuzz(self, count: int) -> None:
        for item in self.generate_list(count):
            print(item)
