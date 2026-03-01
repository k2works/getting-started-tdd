from lib.application.fizz_buzz_list_command import FizzBuzzListCommand
from lib.application.fizz_buzz_value_command import FizzBuzzValueCommand
from lib.domain.model.fizz_buzz_value import FizzBuzzValue
from lib.domain.type.fizz_buzz_type import FizzBuzzType


class TestFizzBuzzCommand:
    class TestFizzBuzzValueCommand:
        def test_単一値を実行する(self) -> None:
            type_ = FizzBuzzType.create(1)
            command = FizzBuzzValueCommand(type_, 15)
            result = command.execute()
            assert result == FizzBuzzValue(15, "FizzBuzz")

        def test_タイプ2で単一値を実行する(self) -> None:
            type_ = FizzBuzzType.create(2)
            command = FizzBuzzValueCommand(type_, 3)
            result = command.execute()
            assert result == FizzBuzzValue(3, "3")

    class TestFizzBuzzListCommand:
        def test_リストを生成する(self) -> None:
            type_ = FizzBuzzType.create(1)
            command = FizzBuzzListCommand(type_)
            result = command.execute()
            assert result.size() == 100
            assert result.get(0) == FizzBuzzValue(1, "1")
            assert result.get(2) == FizzBuzzValue(3, "Fizz")
            assert result.get(4) == FizzBuzzValue(5, "Buzz")
            assert result.get(14) == FizzBuzzValue(15, "FizzBuzz")
            assert result.get(99) == FizzBuzzValue(100, "Buzz")

        def test_タイプ2でリストを生成する(self) -> None:
            type_ = FizzBuzzType.create(2)
            command = FizzBuzzListCommand(type_)
            result = command.execute()
            assert result.size() == 100
            assert result.get(0) == FizzBuzzValue(1, "1")
            assert result.get(2) == FizzBuzzValue(3, "3")
