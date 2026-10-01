"""ボウリングの得点計算（オブジェクト指向でよくある形。状態をインスタンスに持たせる）"""

from src.bowling import 得点計算処理


class ゲーム:
    def __init__(self) -> None:
        self.投球列: list[int] = []

    def 投球処理(self, PINS: int) -> None:
        self.投球列.append(PINS)

    def 連続投球処理(self, PINS: int, N: int) -> None:
        for 番号 in range(1, N + 1):
            self.投球処理(PINS)

    def 得点取得処理(self) -> int:
        return 得点計算処理(self.投球列)
