defmodule FizzBuzz.TypeTest do
  use ExUnit.Case, async: true

  import FizzBuzz.Type

  test "タイプ1は通常の変換をする" do
    通常 = タイプ生成(1)
    assert タイプ変換(通常, 3) == "Fizz"
    assert 通常.名前 == "通常"
  end

  test "タイプ2は数字だけを返す" do
    数字 = タイプ生成(2)
    assert タイプ変換(数字, 3) == "3"
    assert 数字.名前 == "数字限定"
  end

  test "タイプ3は15の倍数だけFizzBuzzを返す" do
    assert タイプ生成(3) |> タイプ変換(15) == "FizzBuzz"
  end

  test "タイプ3は3の倍数を数字で返す" do
    assert タイプ生成(3) |> タイプ変換(3) == "3"
  end

  test "存在しないタイプはエラーになる" do
    assert_raise :タイプ未定義エラー, "該当するタイプは存在しません: 4", fn ->
      タイプ生成(4)
    end
  end

  test "タイプはアトム名のモジュール :タイプ の構造体になる" do
    assert %:タイプ{名前: "通常"} = タイプ生成(1)
  end
end
