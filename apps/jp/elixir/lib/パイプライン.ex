defmodule FizzBuzz.Pipeline do
  @moduledoc "題材 C: 「N を FizzBuzz変換して 装飾して 戻す」をパイプ演算子で書く"

  import FizzBuzz, only: [fizzbuzz_変換: 1]

  @doc "文字列を角括弧で囲む"
  def 装飾(文字列), do: "[#{文字列}]"

  @doc "FizzBuzz 変換してから装飾する"
  def fizzbuzz_装飾(数) do
    数
    |> fizzbuzz_変換()
    |> 装飾()
  end

  @doc "1 から上限までを FizzBuzz 装飾したリストを返す"
  def パイプライン処理(上限), do: Enum.map(1..上限, &fizzbuzz_装飾/1)
end
