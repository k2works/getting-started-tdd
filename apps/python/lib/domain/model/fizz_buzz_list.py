from lib.domain.model.fizz_buzz_value import FizzBuzzValue


class FizzBuzzList:
    """FizzBuzz の結果リストを表すファーストクラスコレクション。"""

    def __init__(self, values: list[FizzBuzzValue] | None = None) -> None:
        self._values: list[FizzBuzzValue] = list(values) if values else []

    def add(self, value: FizzBuzzValue) -> None:
        self._values.append(value)

    def get(self, index: int) -> FizzBuzzValue:
        return self._values[index]

    def size(self) -> int:
        return len(self._values)

    def __eq__(self, other: object) -> bool:
        if not isinstance(other, FizzBuzzList):
            return NotImplemented
        return self._values == other._values

    def __hash__(self) -> int:
        return hash(tuple(self._values))

    def __repr__(self) -> str:
        return "[" + ", ".join(repr(v) for v in self._values) + "]"
