from lib.fizzbuzz_type import FizzBuzzType


class FizzBuzz:
    def __init__(self, type_: int) -> None:
        self._type = FizzBuzzType.create(type_)

    @property
    def type(self) -> FizzBuzzType:
        return self._type

    def generate(self, number: int) -> str:
        return self._type.generate(number)

    def generate_list(self, count: int) -> list[str]:
        return [self.generate(i) for i in range(1, count + 1)]

    def print_fizzbuzz(self, count: int) -> None:
        for item in self.generate_list(count):
            print(item)
