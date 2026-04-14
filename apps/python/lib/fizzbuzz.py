from lib.fizzbuzz_command import FizzBuzzValueCommand
from lib.fizzbuzz_type import FizzBuzzType


class FizzBuzz:
    def __init__(self, type_: int) -> None:
        self._type = FizzBuzzType.create(type_)

    @property
    def type(self) -> FizzBuzzType:
        return self._type

    def generate(self, number: int) -> str:
        return FizzBuzzValueCommand(self._type, number).execute().value

    def generate_list(self, count: int) -> list[str]:
        return [
            FizzBuzzValueCommand(self._type, i).execute().value
            for i in range(1, count + 1)
        ]

    def print_fizzbuzz(self, count: int) -> None:
        for item in self.generate_list(count):
            print(item)
