"""題材 C: パイプライン"""

from 実装.変換 import FizzBuzz変換
from 実装.語順 import して, を


def 装飾(文字列: str) -> str:
    return f"[{文字列}]"


def FizzBuzz装飾(N: int) -> str:
    # なでしこ3: 「NをFizzBuzz変換して装飾して戻す」
    return N | を | FizzBuzz変換 | して | 装飾


def パイプライン処理(N: int) -> list[str]:
    return list(map(FizzBuzz装飾, range(1, N + 1)))
