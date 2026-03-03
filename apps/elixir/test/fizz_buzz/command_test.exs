defmodule FizzBuzz.CommandTest do
  use ExUnit.Case

  alias FizzBuzz.Command.{ValueCommand, ListCommand}
  alias FizzBuzz.Type.Type01
  alias FizzBuzz.Model

  describe "ValueCommand" do
    test "デフォルトで実行できる" do
      result = ValueCommand.execute()
      assert %Model.Value{} = result
    end

    test "指定した数値で実行できる" do
      cmd = %ValueCommand{number: 3, type: %Type01{}}
      result = ValueCommand.execute(cmd)
      assert result.value == "Fizz"
    end

    test "15 の倍数で FizzBuzz を返す" do
      cmd = %ValueCommand{number: 15, type: %Type01{}}
      result = ValueCommand.execute(cmd)
      assert result.value == "FizzBuzz"
    end
  end

  describe "ListCommand" do
    test "デフォルトで 100 件のリストを生成する" do
      result = ListCommand.execute()
      assert Model.List.count(result) == 100
    end

    test "指定した件数でリストを生成する" do
      cmd = %ListCommand{count: 10, type: %Type01{}}
      result = ListCommand.execute(cmd)
      assert Model.List.count(result) == 10
    end
  end
end
