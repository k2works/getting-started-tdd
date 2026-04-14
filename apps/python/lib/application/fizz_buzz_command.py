from abc import ABC, abstractmethod

from lib.domain.model.fizz_buzz_list import FizzBuzzList
from lib.domain.model.fizz_buzz_value import FizzBuzzValue


class FizzBuzzCommand(ABC):
    @abstractmethod
    def execute(self) -> FizzBuzzValue | FizzBuzzList:
        raise NotImplementedError
