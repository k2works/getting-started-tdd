from lib.domain.model.fizz_buzz_value import FizzBuzzValue
from lib.domain.type.fizz_buzz_type import FizzBuzzType


class TestFizzBuzzType:
    class TestType01:
        def setup_method(self) -> None:
            self.type = FizzBuzzType.create(1)

        def test_FizzBuzzを返す(self) -> None:
            assert self.type.generate(15) == FizzBuzzValue(15, "FizzBuzz")

        def test_Fizzを返す(self) -> None:
            assert self.type.generate(3) == FizzBuzzValue(3, "Fizz")

        def test_Buzzを返す(self) -> None:
            assert self.type.generate(5) == FizzBuzzValue(5, "Buzz")

        def test_数を文字列で返す(self) -> None:
            assert self.type.generate(1) == FizzBuzzValue(1, "1")

    class TestType02:
        def setup_method(self) -> None:
            self.type = FizzBuzzType.create(2)

        def test_数をそのまま文字列で返す(self) -> None:
            assert self.type.generate(3) == FizzBuzzValue(3, "3")

        def test_15でも数を返す(self) -> None:
            assert self.type.generate(15) == FizzBuzzValue(15, "15")

    class TestType03:
        def setup_method(self) -> None:
            self.type = FizzBuzzType.create(3)

        def test_FizzBuzzを返す(self) -> None:
            assert self.type.generate(15) == FizzBuzzValue(15, "FizzBuzz")

        def test_その他は数を文字列で返す(self) -> None:
            assert self.type.generate(3) == FizzBuzzValue(3, "3")

    class TestTypeNotDefined:
        def setup_method(self) -> None:
            self.type = FizzBuzzType.create(99)

        def test_空文字を返す(self) -> None:
            assert self.type.generate(1) == FizzBuzzValue(1, "")
