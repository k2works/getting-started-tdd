package フィズバズ

import org.scalatest.funsuite.AnyFunSuite

class タイプテスト extends AnyFunSuite:
  test("タイプ1は通常の変換をする") {
    val 通常 = タイプ生成(1)
    assert(タイプ変換(通常, 3) === "Fizz")
    assert(通常.名前 === "通常")
  }

  test("タイプ2は数字だけを返す") {
    val 数字 = タイプ生成(2)
    assert(タイプ変換(数字, 3) === "3")
    assert(数字.名前 === "数字限定")
  }

  test("タイプ3は15の倍数だけFizzBuzzを返す") {
    assert(タイプ変換(タイプ生成(3), 15) === "FizzBuzz")
  }

  test("タイプ3は3の倍数を数字で返す") {
    assert(タイプ変換(タイプ生成(3), 3) === "3")
  }

  test("存在しないタイプはエラーになる") {
    val 例外 = intercept[IllegalArgumentException](タイプ生成(4))
    assert(例外.getMessage === "該当するタイプは存在しません: 4")
  }

  test("列挙子を日本語のままパターンマッチできる") {
    import タイプ.*
    val 説明 = タイプ生成(3) match
      case 通常         => "通常"
      case 数字限定       => "数字だけ"
      case FizzBuzz限定 => "15 の倍数だけ"
    assert(説明 === "15 の倍数だけ")
  }
