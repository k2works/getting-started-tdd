from __future__ import annotations

from collections.abc import Callable

from lib.domain.model.fizz_buzz_value import FizzBuzzValue


class FizzBuzzList:
    """FizzBuzz の結果リストを表すファーストクラスコレクション。"""

    def __init__(self, values: list[FizzBuzzValue] | None = None) -> None:
        self._values: list[FizzBuzzValue] = list(values) if values else []

    def add(self, value: FizzBuzzValue) -> FizzBuzzList:
        """値を追加した新しいリストを返す（不変）。"""
        return FizzBuzzList(self._values + [value])

    def get(self, index: int) -> FizzBuzzValue:
        return self._values[index]

    def size(self) -> int:
        return len(self._values)

    def filter(self, predicate: Callable[[FizzBuzzValue], bool]) -> FizzBuzzList:
        """条件に合う値だけを含む新しいリストを返す。"""
        return FizzBuzzList([v for v in self._values if predicate(v)])

    def to_formatted_string(self, separator: str = "\n") -> str:
        """フォーマットされた文字列を返す。"""
        return separator.join(repr(v) for v in self._values)

    def group_by_value(self) -> dict[str, list[FizzBuzzValue]]:
        """値でグルーピングする。"""
        groups: dict[str, list[FizzBuzzValue]] = {}
        for v in self._values:
            groups.setdefault(v.value, []).append(v)
        return groups

    def statistics(self) -> dict[str, int]:
        """値ごとの件数を返す。"""
        groups = self.group_by_value()
        return {key: len(values) for key, values in groups.items()}

    def __eq__(self, other: object) -> bool:
        if not isinstance(other, FizzBuzzList):
            return NotImplemented
        return self._values == other._values

    def __hash__(self) -> int:
        return hash(tuple(self._values))

    def __repr__(self) -> str:
        return "[" + ", ".join(repr(v) for v in self._values) + "]"
