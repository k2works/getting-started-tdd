defmodule FizzBuzz.ErrorHandlingTest do
  use ExUnit.Case, async: true

  alias FizzBuzz.{ExceptionBoundary, Safe, SafeList}

  test "safe_generate/1 は成功時に {:ok, value} を返す" do
    assert Safe.safe_generate(15) == {:ok, "FizzBuzz"}
  end

  test "safe_generate/1 は入力エラーを {:error, reason} で返す" do
    assert Safe.safe_generate(0) == {:error, :non_positive}
    assert Safe.safe_generate("3") == {:error, :not_integer}
  end

  test "safe_generate_list/1 は全要素が正しければ一覧を返す" do
    assert SafeList.safe_generate_list([1, 3, 5]) == {:ok, ["1", "Fizz", "Buzz"]}
  end

  test "safe_generate_list/1 は最初の不正要素で停止する" do
    assert SafeList.safe_generate_list([1, -1, 3]) == {:error, {:invalid_item, -1, :non_positive}}
  end

  test "with を使った parse_and_generate/1 は parse エラーを返せる" do
    assert ExceptionBoundary.parse_and_generate("abc") == {:error, :parse_error}
    assert ExceptionBoundary.parse_and_generate("15") == {:ok, "FizzBuzz"}
  end

  test "try/rescue ベースの実装も同じ契約に揃えられる" do
    assert ExceptionBoundary.parse_with_rescue("abc") == {:error, :parse_error}
    assert ExceptionBoundary.parse_with_rescue("5") == {:ok, "Buzz"}
  end
end
