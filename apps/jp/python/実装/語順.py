"""「3を FizzBuzz変換」の SOV 順を、演算子 | で助詞を挟んで再現する

    3 | を | FizzBuzz変換                  -> "Fizz"
    15 | を | FizzBuzz変換 | して | 装飾    -> "[FizzBuzz]"

左辺（int や str）は助詞との | を知らないため、助詞の __ror__ が呼ばれて
目的語を預かり、続く | 動詞 で動詞を適用する。
"""

from collections.abc import Callable
from typing import Generic, TypeVar

甲 = TypeVar("甲")
乙 = TypeVar("乙")
丙 = TypeVar("丙")


class 目的語付き(Generic[甲]):
    def __init__(self, 目的語: 甲) -> None:
        self.目的語 = 目的語

    def __or__(self, 動詞: Callable[[甲], 乙]) -> 乙:
        return 動詞(self.目的語)


class 助詞:
    def __init__(self, 表記: str) -> None:
        self.表記 = 表記

    def __ror__(self, 目的語: 甲) -> 目的語付き[甲]:
        return 目的語付き(目的語)

    def __call__(
        self, 先: Callable[[甲], 乙], 後: Callable[[乙], 丙]
    ) -> Callable[[甲], 丙]:
        """して(FizzBuzz変換, 装飾) は「FizzBuzz変換して装飾する」関数"""
        return lambda x: 後(先(x))


を = 助詞("を")
して = 助詞("して")
