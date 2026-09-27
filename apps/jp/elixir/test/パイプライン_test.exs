defmodule FizzBuzz.PipelineTest do
  use ExUnit.Case, async: true

  import FizzBuzz.Pipeline

  test "装飾すると角括弧で囲む" do
    assert 装飾("Fizz") == "[Fizz]"
  end

  test "5までのパイプライン処理" do
    assert パイプライン処理(5) == ["[1]", "[2]", "[Fizz]", "[4]", "[Buzz]"]
  end

  test "15をFizzBuzz変換して装飾する" do
    assert fizzbuzz_装飾(15) == "[FizzBuzz]"
  end
end
