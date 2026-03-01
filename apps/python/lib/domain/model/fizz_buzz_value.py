class FizzBuzzValue:
    """FizzBuzz の結果を表す値オブジェクト。"""

    def __init__(self, number: int, value: str) -> None:
        self._number = number
        self._value = value

    @property
    def number(self) -> int:
        return self._number

    @property
    def value(self) -> str:
        return self._value

    def __eq__(self, other: object) -> bool:
        if not isinstance(other, FizzBuzzValue):
            return NotImplemented
        return self._number == other._number and self._value == other._value

    def __hash__(self) -> int:
        return hash((self._number, self._value))

    def __repr__(self) -> str:
        return f"{self._number}:{self._value}"
