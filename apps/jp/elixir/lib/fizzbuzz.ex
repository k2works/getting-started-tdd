defmodule FizzBuzz do
  @moduledoc """
  題材 A: FizzBuzz の基本変換。

  `FizzBuzz変換` はラテン文字と漢字が混在する識別子として拒否されるため、
  文字種の境界にアンダースコアを置いて `fizzbuzz_変換` とする。
  """

  @doc "15 の倍数で FizzBuzz、3 の倍数で Fizz、5 の倍数で Buzz、それ以外は数値の文字列を返す"
  @spec fizzbuzz_変換(integer()) :: String.t()
  def fizzbuzz_変換(数) when rem(数, 15) == 0, do: "FizzBuzz"
  def fizzbuzz_変換(数) when rem(数, 3) == 0, do: "Fizz"
  def fizzbuzz_変換(数) when rem(数, 5) == 0, do: "Buzz"
  def fizzbuzz_変換(数), do: Integer.to_string(数)

  @doc "1 から上限までを FizzBuzz 変換したリストを返す"
  @spec fizzbuzz_配列作成(pos_integer()) :: [String.t()]
  def fizzbuzz_配列作成(上限), do: Enum.map(1..上限, &fizzbuzz_変換/1)
end
