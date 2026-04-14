from abc import ABC, abstractmethod

from lib.fizzbuzz_value import FizzBuzzValue


class FizzBuzzType(ABC):
    @staticmethod
    def create(type_: int) -> "FizzBuzzType":
        if type_ == 1:
            return FizzBuzzType01()
        if type_ == 2:
            return FizzBuzzType02()
        if type_ == 3:
            return FizzBuzzType03()
        return FizzBuzzTypeNotDefined()

    @abstractmethod
    def generate(self, number: int) -> FizzBuzzValue:
        raise NotImplementedError

    def _is_fizz(self, number: int) -> bool:
        return number % 3 == 0

    def _is_buzz(self, number: int) -> bool:
        return number % 5 == 0

    def _is_fizz_buzz(self, number: int) -> bool:
        return number % 15 == 0


class FizzBuzzType01(FizzBuzzType):
    def generate(self, number: int) -> FizzBuzzValue:
        if self._is_fizz_buzz(number):
            return FizzBuzzValue(number, "FizzBuzz")
        if self._is_fizz(number):
            return FizzBuzzValue(number, "Fizz")
        if self._is_buzz(number):
            return FizzBuzzValue(number, "Buzz")
        return FizzBuzzValue(number, str(number))


class FizzBuzzType02(FizzBuzzType):
    def generate(self, number: int) -> FizzBuzzValue:
        return FizzBuzzValue(number, str(number))


class FizzBuzzType03(FizzBuzzType):
    def generate(self, number: int) -> FizzBuzzValue:
        if self._is_fizz_buzz(number):
            return FizzBuzzValue(number, "FizzBuzz")
        return FizzBuzzValue(number, str(number))


class FizzBuzzTypeNotDefined(FizzBuzzType):
    def generate(self, number: int) -> FizzBuzzValue:
        return FizzBuzzValue(number, "")
