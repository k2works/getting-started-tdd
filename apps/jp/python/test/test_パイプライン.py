"""題材 C: パイプライン"""

from 実装.パイプライン import パイプライン処理, 装飾


def test_装飾すると角括弧で囲む() -> None:
    assert 装飾("Fizz") == "[Fizz]"


def test_5までのパイプライン処理() -> None:
    assert パイプライン処理(5) == ["[1]", "[2]", "[Fizz]", "[4]", "[Buzz]"]
