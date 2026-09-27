"""題材 D: 安全変換（成功・失敗を値で返す）"""

from dataclasses import dataclass
from typing import TypeAlias

from 実装.変換 import FizzBuzz変換


@dataclass(frozen=True)
class 成功:
    値: str


@dataclass(frozen=True)
class 失敗:
    エラー: str


変換結果: TypeAlias = 成功 | 失敗


def 安全変換(N: object) -> 変換結果:
    if not isinstance(N, int):
        return 失敗(f"数値を指定してください: {N}")
    if N <= 0:
        return 失敗(f"正の数を指定してください: {N}")
    return 成功(FizzBuzz変換(N))
