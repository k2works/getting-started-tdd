from lib.application.fizz_buzz_list_command import FizzBuzzListCommand
from lib.domain.model.fizz_buzz_list import FizzBuzzList
from lib.domain.model.fizz_buzz_value import FizzBuzzValue
from lib.domain.type.fizz_buzz_type import FizzBuzzType


class TestFizzBuzzList:
    def test_空のリストを作成できる(self) -> None:
        lst = FizzBuzzList()
        assert lst.size() == 0

    # 章 11: add は新しいリストを返す（不変）
    def test_値を追加できる(self) -> None:
        lst1 = FizzBuzzList()
        lst2 = lst1.add(FizzBuzzValue(1, "1"))
        assert lst1.size() == 0  # 元のリストは変更されない
        assert lst2.size() == 1
        assert lst2.get(0) == FizzBuzzValue(1, "1")

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

    # 章 10: フィルタリング
    def test_条件でフィルタリングできる(self) -> None:
        type_ = FizzBuzzType.create(1)
        command = FizzBuzzListCommand(type_)
        result = command.execute()
        fizzes = result.filter(lambda v: v.value == "Fizz")
        assert fizzes.size() > 0
        assert all(fizzes.get(i).value == "Fizz" for i in range(fizzes.size()))

    # 章 10: フォーマット文字列
    def test_フォーマット文字列を生成できる(self) -> None:
        lst = FizzBuzzList([FizzBuzzValue(1, "1"), FizzBuzzValue(3, "Fizz")])
        assert lst.to_formatted_string(", ") == "1:1, 3:Fizz"

    # 章 11: 統計情報
    def test_統計情報を取得できる(self) -> None:
        type_ = FizzBuzzType.create(1)
        command = FizzBuzzListCommand(type_)
        result = command.execute()
        stats = result.statistics()
        assert stats["Fizz"] > 0
        assert stats["Buzz"] > 0
        assert stats["FizzBuzz"] > 0

    # 章 11: グルーピング
    def test_値でグルーピングできる(self) -> None:
        type_ = FizzBuzzType.create(1)
        command = FizzBuzzListCommand(type_)
        result = command.execute()
        groups = result.group_by_value()
        assert "Fizz" in groups
        assert "Buzz" in groups
        assert "FizzBuzz" in groups
