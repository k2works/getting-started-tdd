"""FizzBuzz のテスト（なでしこ3 版の test/fizzbuzz_test.nako3 と同じ検証を並べる）"""

import pytest

from src.fizzbuzz import FizzBuzzリスト作成処理, FizzBuzz変換処理, FizzBuzz表示処理


@pytest.mark.parametrize(
    ("数", "期待"),
    [
        pytest.param(1, "1", id="1を渡したら文字列1を返す"),
        pytest.param(2, "2", id="2を渡したら文字列2を返す"),
        pytest.param(3, "Fizz", id="3を渡したらFizzを返す"),
        pytest.param(6, "Fizz", id="6を渡したらFizzを返す"),
        pytest.param(5, "Buzz", id="5を渡したらBuzzを返す"),
        pytest.param(10, "Buzz", id="10を渡したらBuzzを返す"),
        pytest.param(15, "FizzBuzz", id="15を渡したらFizzBuzzを返す"),
    ],
)
def test_FizzBuzz変換処理(数: int, 期待: str) -> None:
    assert FizzBuzz変換処理(数) == 期待


def test_15まで作ると15件になる() -> None:
    assert len(FizzBuzzリスト作成処理(15)) == 15


def test_15まで作ったリストの並び() -> None:
    assert (
        ",".join(FizzBuzzリスト作成処理(15))
        == "1,2,Fizz,4,Buzz,Fizz,7,8,Fizz,Buzz,11,Fizz,13,14,FizzBuzz"
    )


def test_15まで表示する(capsys: pytest.CaptureFixture[str]) -> None:
    FizzBuzz表示処理(15)
    assert capsys.readouterr().out.splitlines() == FizzBuzzリスト作成処理(15)
