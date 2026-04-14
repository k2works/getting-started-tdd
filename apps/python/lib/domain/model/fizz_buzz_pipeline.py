from collections.abc import Iterator

from lib.domain.model.fizz_buzz_value import FizzBuzzValue
from lib.domain.type.fizz_buzz_type import FizzBuzzType


def fizzbuzz_pipeline(type_: FizzBuzzType, count: int) -> Iterator[FizzBuzzValue]:
    for i in range(1, count + 1):
        yield type_.generate(i)
