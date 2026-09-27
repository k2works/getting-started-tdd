defmodule FizzBuzz.SafeTest do
  use ExUnit.Case, async: true

  import FizzBuzz.Safe

  test "正の数は成功になる" do
    assert 安全変換(3) == {:成功, "Fizz"}
  end

  test "0は失敗になる" do
    assert 安全変換(0) == {:失敗, "正の数を指定してください: 0"}
  end

  test "数値でなければ失敗になる" do
    assert 安全変換("a") == {:失敗, "数値を指定してください: a"}
  end

  test "case で :成功 と :失敗 を振り分ける" do
    表示 =
      case 安全変換(-1) do
        {:成功, 値} -> 値
        {:失敗, エラー} -> "失敗: #{エラー}"
      end

    assert 表示 == "失敗: 正の数を指定してください: -1"
  end
end
