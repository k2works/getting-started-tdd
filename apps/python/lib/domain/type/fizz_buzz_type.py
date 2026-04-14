from abc import ABC, abstractmethod
from enum import Enum

from lib.domain.model.fizz_buzz_value import FizzBuzzValue


class FizzBuzzTypeName(Enum):
    STANDARD = "standard"
    NUMBER_ONLY = "number_only"
    FIZZ_BUZZ_ONLY = "fizz_buzz_only"


class FizzBuzzType(ABC):
    @staticmethod
    def create(type_: int) -> "FizzBuzzType | None":
        types: dict[int, type[FizzBuzzType]] = {
            1: FizzBuzzType01,
            2: FizzBuzzType02,
            3: FizzBuzzType03,
        }
        cls = types.get(type_)
        return cls() if cls else None

    @staticmethod
    def create_from_name(name: FizzBuzzTypeName) -> "FizzBuzzType":
        mapping: dict[FizzBuzzTypeName, type[FizzBuzzType]] = {
            FizzBuzzTypeName.STANDARD: FizzBuzzType01,
            FizzBuzzTypeName.NUMBER_ONLY: FizzBuzzType02,
            FizzBuzzTypeName.FIZZ_BUZZ_ONLY: FizzBuzzType03,
        }
        return mapping[name]()

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
