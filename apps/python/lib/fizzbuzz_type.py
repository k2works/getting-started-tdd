from abc import ABC, abstractmethod


class FizzBuzzType(ABC):
    @staticmethod
    def create(type_: int) -> "FizzBuzzType":
        if type_ == 1:
            return FizzBuzzType01()
        if type_ == 2:
            return FizzBuzzType02()
        if type_ == 3:
            return FizzBuzzType03()
        raise ValueError("未定義のタイプです")

    @abstractmethod
    def generate(self, number: int) -> str:
        raise NotImplementedError

    def _is_fizz(self, number: int) -> bool:
        return number % 3 == 0

    def _is_buzz(self, number: int) -> bool:
        return number % 5 == 0

    def _is_fizz_buzz(self, number: int) -> bool:
        return number % 15 == 0


class FizzBuzzType01(FizzBuzzType):
    def generate(self, number: int) -> str:
        if self._is_fizz_buzz(number):
            return "FizzBuzz"
        if self._is_fizz(number):
            return "Fizz"
        if self._is_buzz(number):
            return "Buzz"
        return str(number)


class FizzBuzzType02(FizzBuzzType):
    def generate(self, number: int) -> str:
        return str(number)


class FizzBuzzType03(FizzBuzzType):
    def generate(self, number: int) -> str:
        if self._is_fizz_buzz(number):
            return "FizzBuzz"
        return str(number)
