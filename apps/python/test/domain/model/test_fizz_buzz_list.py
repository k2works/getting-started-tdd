from lib.domain.model.fizz_buzz_list import FizzBuzzList
from lib.domain.model.fizz_buzz_value import FizzBuzzValue


class TestFizzBuzzList:
    def test_空のリストを作成できる(self) -> None:
        lst = FizzBuzzList()
        assert lst.size() == 0

    def test_値を追加できる(self) -> None:
        lst = FizzBuzzList()
        lst.add(FizzBuzzValue(1, "1"))
        assert lst.size() == 1
        assert lst.get(0) == FizzBuzzValue(1, "1")

    def test_初期値付きで作成できる(self) -> None:
        values = [FizzBuzzValue(1, "1"), FizzBuzzValue(2, "2")]
        lst = FizzBuzzList(values)
        assert lst.size() == 2

    def test_同じ内容は等しい(self) -> None:
        lst1 = FizzBuzzList([FizzBuzzValue(1, "1")])
        lst2 = FizzBuzzList([FizzBuzzValue(1, "1")])
        assert lst1 == lst2

    def test_ハッシュが等しい(self) -> None:
        lst1 = FizzBuzzList([FizzBuzzValue(1, "1")])
        lst2 = FizzBuzzList([FizzBuzzValue(1, "1")])
        assert hash(lst1) == hash(lst2)

    def test_文字列表現(self) -> None:
        lst = FizzBuzzList([FizzBuzzValue(1, "1"), FizzBuzzValue(3, "Fizz")])
        assert repr(lst) == "[1:1, 3:Fizz]"
