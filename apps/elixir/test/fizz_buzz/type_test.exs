defmodule FizzBuzz.TypeTest do
  use ExUnit.Case

  alias FizzBuzz.Type
  alias FizzBuzz.Type.{Type01, Type02, Type03, Generatable}

  describe "Type01" do
    test "1 を渡すと 1 を返す" do
      assert Generatable.generate(%Type01{}, 1) == "1"
    end

    test "3 の倍数を渡すと Fizz を返す" do
      assert Generatable.generate(%Type01{}, 3) == "Fizz"
    end

    test "5 の倍数を渡すと Buzz を返す" do
      assert Generatable.generate(%Type01{}, 5) == "Buzz"
    end

    test "15 の倍数を渡すと FizzBuzz を返す" do
      assert Generatable.generate(%Type01{}, 15) == "FizzBuzz"
    end
  end

  describe "Type02" do
    test "数値を文字列に変換する" do
      assert Generatable.generate(%Type02{}, 1) == "1"
    end
  end

  describe "Type03" do
    test "1 を渡すと 1 を返す" do
      assert Generatable.generate(%Type03{}, 1) == "1"
    end

    test "3 を渡すと Fizz を返す" do
      assert Generatable.generate(%Type03{}, 3) == "Fizz"
    end

    test "15 の倍数で FizzBuzz を返す" do
      assert Generatable.generate(%Type03{}, 15) == "FizzBuzz"
    end
  end

  describe "create/1" do
    test "タイプ 1 を生成できる" do
      assert Type.create(1) == {:ok, %Type01{}}
    end

    test "タイプ 2 を生成できる" do
      assert Type.create(2) == {:ok, %Type02{}}
    end

    test "タイプ 3 を生成できる" do
      assert Type.create(3) == {:ok, %Type03{}}
    end

    test "未定義のタイプでエラーを返す" do
      assert Type.create(4) == {:error, "未定義のタイプです"}
    end
  end
end
