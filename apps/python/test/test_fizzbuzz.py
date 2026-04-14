from pytest import CaptureFixture, raises

from lib.application.fizz_buzz_list_command import FizzBuzzListCommand
from lib.application.fizz_buzz_value_command import FizzBuzzValueCommand
from lib.domain.model.fizz_buzz_list import FizzBuzzList
from lib.domain.model.fizz_buzz_pipeline import fizzbuzz_pipeline
from lib.domain.model.fizz_buzz_value import FizzBuzzValue
from lib.domain.type.fizz_buzz_type import FizzBuzzType, FizzBuzzTypeNotDefined
from lib.fizzbuzz import FizzBuzz


class TestFizzBuzzValue:
    def test_値を保持する(self) -> None:
        value = FizzBuzzValue(1, "1")
        assert value.number == 1
        assert value.value == "1"

    def test_同じ値は等しい(self) -> None:
        assert FizzBuzzValue(1, "1") == FizzBuzzValue(1, "1")

    def test_文字列表現(self) -> None:
        assert repr(FizzBuzzValue(3, "Fizz")) == "3:Fizz"


class TestFizzBuzzList:
    def test_値を追加できる(self) -> None:
        values = FizzBuzzList()
        values2 = values.add(FizzBuzzValue(1, "1"))

        assert values.size() == 0
        assert values2.size() == 1
        assert values2.get(0) == FizzBuzzValue(1, "1")

    def test_同じ値は等しい(self) -> None:
        assert FizzBuzzList([FizzBuzzValue(1, "1")]) == FizzBuzzList(
            [FizzBuzzValue(1, "1")]
        )

    def test_文字列表現(self) -> None:
        values = FizzBuzzList([FizzBuzzValue(3, "Fizz")])
        assert repr(values) == "[3:Fizz]"

    def test_Fizzだけをフィルタリングする(self) -> None:
        values = FizzBuzzListCommand(FizzBuzzType.create(1)).execute()
        fizzes = values.filter(lambda value: value.value == "Fizz")

        assert fizzes.size() > 0
        assert all(fizzes.get(i).value == "Fizz" for i in range(fizzes.size()))

    def test_整形文字列を返す(self) -> None:
        values = FizzBuzzList([FizzBuzzValue(1, "1"), FizzBuzzValue(2, "2")])

        assert values.to_formatted_string(",") == "1:1,2:2"

    def test_統計情報を取得する(self) -> None:
        values = FizzBuzzListCommand(FizzBuzzType.create(1)).execute()
        stats = values.statistics()

        assert stats["Fizz"] > 0
        assert stats["Buzz"] > 0
        assert stats["FizzBuzz"] > 0


class TestFizzBuzzPipeline:
    def test_先頭10件を取得できる(self) -> None:
        values = list(fizzbuzz_pipeline(FizzBuzzType.create(1), 10))

        assert len(values) == 10
        assert values[0] == FizzBuzzValue(1, "1")
        assert values[2] == FizzBuzzValue(3, "Fizz")
        assert values[4] == FizzBuzzValue(5, "Buzz")


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
            del self.fizzbuzz.type


class TestFizzBuzzValueCommand:
    def test_値を返す(self) -> None:
        command = FizzBuzzValueCommand(FizzBuzzType.create(1), 15)

        assert command.execute() == FizzBuzzValue(15, "FizzBuzz")


class TestFizzBuzzListCommand:
    def test_100件の値を返す(self) -> None:
        command = FizzBuzzListCommand(FizzBuzzType.create(1))

        result = command.execute()

        assert isinstance(result, FizzBuzzList)
        assert result.size() == 100
        assert result.get(0) == FizzBuzzValue(1, "1")
        assert result.get(2) == FizzBuzzValue(3, "Fizz")
        assert result.get(4) == FizzBuzzValue(5, "Buzz")
        assert result.get(14) == FizzBuzzValue(15, "FizzBuzz")


class TestFizzBuzzTypeFactory:
    def test_未定義のタイプはNullObjectを返す(self) -> None:
        fizzbuzz_type = FizzBuzzType.create(4)

        assert isinstance(fizzbuzz_type, FizzBuzzTypeNotDefined)
        assert fizzbuzz_type.generate(1) == FizzBuzzValue(1, "")
