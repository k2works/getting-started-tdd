"""題材 B: タイプ生成（関数を持つ値オブジェクトによるポリモーフィズム）"""

from collections.abc import Callable
from dataclasses import dataclass
from enum import IntEnum

from 実装.変換 import FizzBuzz変換

変換関数 = Callable[[int], str]


class タイプ番号(IntEnum):
    通常 = 1
    数字限定 = 2
    FizzBuzz限定 = 3


@dataclass(frozen=True)
class タイプ:
    名前: str
    変換: 変換関数


class 該当タイプなしエラー(ValueError):
    def __init__(self, 番号: int) -> None:
        super().__init__(f"該当するタイプは存在しません: {番号}")


def 数字限定変換(N: int) -> str:
    return str(N)


def FizzBuzz限定変換(N: int) -> str:
    return "FizzBuzz" if N % 15 == 0 else str(N)


_タイプ一覧: dict[int, タイプ] = {
    タイプ番号.通常: タイプ("通常", FizzBuzz変換),
    タイプ番号.数字限定: タイプ("数字限定", 数字限定変換),
    タイプ番号.FizzBuzz限定: タイプ("FizzBuzz限定", FizzBuzz限定変換),
}


def タイプ生成(番号: int) -> タイプ:
    if 番号 not in _タイプ一覧:
        raise 該当タイプなしエラー(番号)
    return _タイプ一覧[番号]


def タイプ変換(対象: タイプ, N: int) -> str:
    return 対象.変換(N)
