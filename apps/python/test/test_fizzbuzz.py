from pytest import CaptureFixture, raises

from lib.fizzbuzz import FizzBuzz
from lib.fizzbuzz_type import FizzBuzzType


class TestFizzBuzzType01:
    def setup_method(self) -> None:
        self.fizzbuzz = FizzBuzz(1)

    def test_FizzBuzzを返す(self) -> None:
        assert self.fizzbuzz.generate(15) == "FizzBuzz"

    def test_Fizzを返す(self) -> None:
        assert self.fizzbuzz.generate(3) == "Fizz"

    def test_Buzzを返す(self) -> None:
        assert self.fizzbuzz.generate(5) == "Buzz"

    def test_数を文字列で返す(self) -> None:
        assert self.fizzbuzz.generate(1) == "1"


class TestFizzBuzzType02:
    def setup_method(self) -> None:
        self.fizzbuzz = FizzBuzz(2)

    def test_数をそのまま文字列で返す(self) -> None:
        assert self.fizzbuzz.generate(3) == "3"


class TestFizzBuzzType03:
    def setup_method(self) -> None:
        self.fizzbuzz = FizzBuzz(3)

    def test_FizzBuzzを返す(self) -> None:
        assert self.fizzbuzz.generate(15) == "FizzBuzz"

    def test_その他は数を文字列で返す(self) -> None:
        assert self.fizzbuzz.generate(3) == "3"


class TestFizzBuzzWrapper:
    def setup_method(self) -> None:
        self.fizzbuzz = FizzBuzz(1)

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

    def test_プリントする(self, capsys: CaptureFixture[str]) -> None:
        self.fizzbuzz.print_fizzbuzz(15)
        captured = capsys.readouterr()
        lines = captured.out.strip().split("\n")

        assert len(lines) == 15
        assert lines[0] == "1"
        assert lines[2] == "Fizz"
        assert lines[4] == "Buzz"
        assert lines[14] == "FizzBuzz"

    def test_typeを読み取れる(self) -> None:
        assert isinstance(self.fizzbuzz.type, FizzBuzzType)

    def test_typeは書き換えられない(self) -> None:
        with raises(AttributeError):
            object.__setattr__(self.fizzbuzz, "type", 2)


class TestFizzBuzzTypeFactory:
    def test_未定義のタイプは例外を送出する(self) -> None:
        with raises(ValueError):
            FizzBuzzType.create(4)
