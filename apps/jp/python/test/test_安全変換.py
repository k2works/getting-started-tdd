"""題材 D: 安全変換"""

from 実装.安全変換 import 失敗, 安全変換, 成功


def test_正の数は成功になる() -> None:
    assert 安全変換(3) == 成功("Fizz")


def test_0は失敗になる() -> None:
    assert 安全変換(0) == 失敗("正の数を指定してください: 0")


def test_数値でなければ失敗になる() -> None:
    assert 安全変換("a") == 失敗("数値を指定してください: a")
