"""ボウリングのテスト（なでしこ3 版の test/bowling_test.nako3 と同じ検証を並べる）"""

import pytest

from src.bowling import 同値連結処理, 得点計算処理


@pytest.mark.parametrize(
    ("投球列", "期待"),
    [
        pytest.param(同値連結処理([], 0, 20), 0, id="ガターゲームは0点"),
        pytest.param(同値連結処理([], 1, 20), 20, id="すべて1ピンなら20点"),
        pytest.param(
            同値連結処理([5, 5, 3], 0, 17), 16, id="スペアは次の1投を加算する"
        ),
        pytest.param(
            同値連結処理([10, 3, 4], 0, 16), 24, id="ストライクは次の2投を加算する"
        ),
        pytest.param(同値連結処理([], 10, 12), 300, id="パーフェクトゲームは300点"),
    ],
)
def test_得点計算処理(投球列: list[int], 期待: int) -> None:
    assert 得点計算処理(投球列) == 期待


def test_0件の連結は元の配列のまま() -> None:
    assert 同値連結処理([1, 2], 9, 0) == [1, 2]
