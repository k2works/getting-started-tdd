"""語順の再現: 「3を FizzBuzz変換」"""

from 実装.パイプライン import 装飾
from 実装.変換 import FizzBuzz変換
from 実装.語順 import して, を


def test_3をFizzBuzz変換するとFizzを返す() -> None:
    assert (3 | を | FizzBuzz変換) == "Fizz"


def test_15をFizzBuzz変換して装飾する() -> None:
    assert (15 | を | FizzBuzz変換 | して | 装飾) == "[FizzBuzz]"


def test_FizzBuzz変換して装飾する関数を合成する() -> None:
    assert して(FizzBuzz変換, 装飾)(3) == "[Fizz]"
