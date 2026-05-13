defmodule FizzBuzz.PatternMatchingTest do
  use ExUnit.Case, async: true

  alias FizzBuzz.Factory
  alias FizzBuzz.Model.Type02
  alias FizzBuzz.Renderer
  alias FizzBuzz.Validator

  test "create/1 は 3 を Type02 として生成する" do
    assert %Type02{} = Factory.create(3)
  end

  test "validate/1 は正の整数を {:ok, value} で返す" do
    assert Validator.validate(10) == {:ok, 10}
  end

  test "validate/1 は不正な入力を {:error, reason} で返す" do
    assert Validator.validate(0) == {:error, :non_positive}
    assert Validator.validate("10") == {:error, :not_integer}
  end

  test "from_result/1 はタグ付きタプルを文字列化する" do
    assert Renderer.from_result({:ok, "Fizz"}) == "ok: Fizz"
    assert Renderer.from_result({:error, :not_integer}) == "error: not_integer"
  end

  test "classify/1 は cond で優先順位どおりに判定する" do
    assert Renderer.classify(15) == :fizz_buzz
    assert Renderer.classify(6) == :fizz
    assert Renderer.classify(10) == :buzz
    assert Renderer.classify(7) == :number
  end
end
