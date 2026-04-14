from abc import ABC, abstractmethod

from lib.fizzbuzz_list import FizzBuzzList
from lib.fizzbuzz_type import FizzBuzzType
from lib.fizzbuzz_value import FizzBuzzValue


class FizzBuzzCommand(ABC):
    @abstractmethod
    def execute(self) -> FizzBuzzValue | FizzBuzzList:
        raise NotImplementedError


class FizzBuzzValueCommand(FizzBuzzCommand):
    def __init__(self, type_: FizzBuzzType, number: int) -> None:
        self._type = type_
        self._number = number

    def execute(self) -> FizzBuzzValue:
        return self._type.generate(self._number)


class FizzBuzzListCommand(FizzBuzzCommand):
    MAX_NUMBER: int = 100

    def __init__(self, type_: FizzBuzzType) -> None:
        self._type = type_

    def execute(self) -> FizzBuzzList:
        result = FizzBuzzList()
        for i in range(1, self.MAX_NUMBER + 1):
            result.add(self._type.generate(i))
        return result
