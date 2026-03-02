from lib.domain.model.fizz_buzz_value import FizzBuzzValue


class TestFizzBuzzValue:
    def test_値を保持する(self) -> None:
        value = FizzBuzzValue(1, "1")
        assert value.number == 1
        assert value.value == "1"

    def test_同じ値は等しい(self) -> None:
        assert FizzBuzzValue(1, "1") == FizzBuzzValue(1, "1")

    def test_異なる値は等しくない(self) -> None:
        assert FizzBuzzValue(1, "1") != FizzBuzzValue(2, "2")

    def test_文字列表現(self) -> None:
        assert repr(FizzBuzzValue(3, "Fizz")) == "3:Fizz"

    def test_ハッシュが等しい(self) -> None:
        assert hash(FizzBuzzValue(1, "1")) == hash(FizzBuzzValue(1, "1"))
