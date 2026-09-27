"""題材 B: タイプ生成"""

import pytest

from 実装.タイプ import タイプ変換, タイプ生成, タイプ番号, 該当タイプなしエラー


class Testタイプ生成:
    def test_タイプ1は通常の変換をする(self) -> None:
        通常 = タイプ生成(タイプ番号.通常)
        assert タイプ変換(通常, 3) == "Fizz"
        assert 通常.名前 == "通常"

    def test_タイプ2は数字だけを返す(self) -> None:
        数字 = タイプ生成(タイプ番号.数字限定)
        assert タイプ変換(数字, 3) == "3"
        assert 数字.名前 == "数字限定"

    def test_タイプ3は15の倍数だけFizzBuzzを返す(self) -> None:
        assert タイプ変換(タイプ生成(3), 15) == "FizzBuzz"

    def test_タイプ3は3の倍数を数字で返す(self) -> None:
        assert タイプ変換(タイプ生成(3), 3) == "3"

    def test_存在しないタイプはエラーになる(self) -> None:
        with pytest.raises(
            該当タイプなしエラー, match="該当するタイプは存在しません: 4"
        ):
            タイプ生成(4)
