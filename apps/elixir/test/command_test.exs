defmodule FizzBuzz.CommandTest do
  use ExUnit.Case, async: true

  alias FizzBuzz.Command.{ListCommand, ValueCommand}

  test "ValueCommand は単一値を処理する" do
    assert ValueCommand.run(3) == {:ok, "Fizz"}
  end

  test "ValueCommand は不正値でエラーを返す" do
    assert ValueCommand.run(0) == {:error, :invalid_number}
    assert ValueCommand.run("3") == {:error, :invalid_number}
  end

  test "ListCommand は 1..limit の結果一覧を返す" do
    assert ListCommand.run(5) == {:ok, ["1", "2", "Fizz", "4", "Buzz"]}
  end

  test "ListCommand は不正値でエラーを返す" do
    assert ListCommand.run(-1) == {:error, :invalid_limit}
  end
end
