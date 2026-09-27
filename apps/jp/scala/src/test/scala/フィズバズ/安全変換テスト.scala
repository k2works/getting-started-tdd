package フィズバズ

import org.scalatest.funsuite.AnyFunSuite

class 安全変換テスト extends AnyFunSuite:
  test("正の数は成功になる") {
    assert(安全変換(3) === 変換結果.成功("Fizz"))
  }

  test("0は失敗になる") {
    assert(安全変換(0) === 変換結果.失敗("正の数を指定してください: 0"))
  }

  test("結果はパターンマッチで取り出せる") {
    // 日本語の識別子は小文字で始まらないため、パターン中では変数束縛ではなく定数参照になる。
    // `値 @ _` と書くと変数として束縛できる。
    val 表示 = 安全変換(0) match
      case 変換結果.成功(値 @ _)   => s"成功 $値"
      case 変換結果.失敗(エラー @ _) => s"失敗 $エラー"
    assert(表示 === "失敗 正の数を指定してください: 0")
  }
