from __future__ import annotations

from abc import ABC, abstractmethod
from typing import TYPE_CHECKING

from lib.domain.model.fizz_buzz_value import FizzBuzzValue

if TYPE_CHECKING:
    from lib.domain.type.fizz_buzz_type_name import FizzBuzzTypeName


class FizzBuzzType(ABC):
    """FizzBuzz タイプの抽象基底クラス。"""

    @abstractmethod
    def generate(self, number: int) -> FizzBuzzValue:
        pass

    def _is_fizz(self, number: int) -> bool:
        return number % 3 == 0

    def _is_buzz(self, number: int) -> bool:
        return number % 5 == 0

    def _is_fizz_buzz(self, number: int) -> bool:
        return number % 15 == 0

    @staticmethod
    def create(type_: int) -> FizzBuzzType:
        from lib.domain.type.fizz_buzz_type_01 import FizzBuzzType01
        from lib.domain.type.fizz_buzz_type_02 import FizzBuzzType02
        from lib.domain.type.fizz_buzz_type_03 import FizzBuzzType03
        from lib.domain.type.fizz_buzz_type_not_defined import (
            FizzBuzzTypeNotDefined,
        )

        types: dict[int, type[FizzBuzzType]] = {
            1: FizzBuzzType01,
            2: FizzBuzzType02,
            3: FizzBuzzType03,
        }
        return types.get(type_, FizzBuzzTypeNotDefined)()

    @staticmethod
    def create_from_name(name: FizzBuzzTypeName) -> FizzBuzzType:
        from lib.domain.type.fizz_buzz_type_01 import FizzBuzzType01
        from lib.domain.type.fizz_buzz_type_02 import FizzBuzzType02
        from lib.domain.type.fizz_buzz_type_03 import FizzBuzzType03
        from lib.domain.type.fizz_buzz_type_name import FizzBuzzTypeName

        mapping: dict[FizzBuzzTypeName, type[FizzBuzzType]] = {
            FizzBuzzTypeName.STANDARD: FizzBuzzType01,
            FizzBuzzTypeName.NUMBER_ONLY: FizzBuzzType02,
            FizzBuzzTypeName.FIZZ_BUZZ_ONLY: FizzBuzzType03,
        }
        return mapping[name]()
