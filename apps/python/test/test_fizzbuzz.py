import pytest

from lib.fizzbuzz import FizzBuzz


class TestFizzBuzz:
    def setup_method(self) -> None:
        self.fizzbuzz = FizzBuzz()

    # 章 1: 仮実装
    def test_1を渡したら文字列1を返す(self) -> None:
        assert self.fizzbuzz.generate(1) == "1"

    # 章 2: 三角測量
    def test_2を渡したら文字列2を返す(self) -> None:
        assert self.fizzbuzz.generate(2) == "2"

    # 章 2: 明白な実装
    def test_3を渡したら文字列Fizzを返す(self) -> None:
        assert self.fizzbuzz.generate(3) == "Fizz"

    def test_4を渡したら文字列4を返す(self) -> None:
        assert self.fizzbuzz.generate(4) == "4"

    def test_5を渡したら文字列Buzzを返す(self) -> None:
        assert self.fizzbuzz.generate(5) == "Buzz"

    def test_15を渡したら文字列FizzBuzzを返す(self) -> None:
        assert self.fizzbuzz.generate(15) == "FizzBuzz"

    # 章 3: リスト生成
    def test_1から100までのFizzBuzzを生成する(self) -> None:
        result = self.fizzbuzz.generate_list(100)
        assert len(result) == 100
        assert result[0] == "1"
        assert result[1] == "2"
        assert result[2] == "Fizz"
        assert result[3] == "4"
        assert result[4] == "Buzz"
        assert result[5] == "Fizz"
        assert result[14] == "FizzBuzz"
        assert result[99] == "Buzz"

    # 章 3: プリント機能
    def test_プリントする(self, capsys: pytest.CaptureFixture[str]) -> None:
        self.fizzbuzz.print_fizzbuzz(15)
        captured = capsys.readouterr()
        lines = captured.out.strip().split("\n")
        assert len(lines) == 15
        assert lines[0] == "1"
        assert lines[2] == "Fizz"
        assert lines[4] == "Buzz"
        assert lines[14] == "FizzBuzz"
