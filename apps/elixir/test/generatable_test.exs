defmodule FizzBuzz.GeneratableTest do
  use ExUnit.Case, async: true

  alias FizzBuzz.Generatable
  alias FizzBuzz.Model.{Type01, Type02, Type03, Value}

  test "Type01 は数値文字列を返す" do
    value = %Value{number: 1}
    assert Generatable.generate(%Type01{value: value}) == "1"
  end

  test "Type02 は Fizz を返す" do
    value = %Value{number: 3}
    assert Generatable.generate(%Type02{value: value}) == "Fizz"
  end

  test "Type03 は Buzz を返す" do
    value = %Value{number: 5}
    assert Generatable.generate(%Type03{value: value}) == "Buzz"
  end

  test "Value は number が必須" do
    assert_raise ArgumentError, fn ->
      struct!(Value, %{})
    end
  end
end
