"""題材 A: FizzBuzz 変換"""

import pytest

from 実装.変換 import FizzBuzz変換, FizzBuzz配列作成


@pytest.mark.parametrize(
    ("数", "期待"),
    [
        pytest.param(3, "Fizz", id="3を渡したらFizzを返す"),
        pytest.param(5, "Buzz", id="5を渡したらBuzzを返す"),
        pytest.param(15, "FizzBuzz", id="15を渡したらFizzBuzzを返す"),
        pytest.param(1, "1", id="1を渡したら文字列1を返す"),
        pytest.param(2, "2", id="2を渡したら文字列2を返す"),
    ],
)
def test_FizzBuzz変換(数: int, 期待: str) -> None:
    assert FizzBuzz変換(数) == 期待


def test_15まで作ると15件になる() -> None:
    assert len(FizzBuzz配列作成(15)) == 15


def test_15まで作った配列の並び() -> None:
    """15まで作った配列を「,」で結合すると FizzBuzz の並びになる"""
    assert (
        ",".join(FizzBuzz配列作成(15))
        == "1,2,Fizz,4,Buzz,Fizz,7,8,Fizz,Buzz,11,Fizz,13,14,FizzBuzz"
    )
