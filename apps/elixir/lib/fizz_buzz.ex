defmodule FizzBuzz do
  @moduledoc """
  FizzBuzz の公開 API モジュール。
  """

  @doc """
  数値を FizzBuzz 文字列に変換する。
  """
  def generate(number) when is_integer(number) and number > 0 do
    cond do
      rem(number, 15) == 0 -> "FizzBuzz"
      rem(number, 3) == 0 -> "Fizz"
      rem(number, 5) == 0 -> "Buzz"
      true -> Integer.to_string(number)
    end
  end

  @doc """
  1 から count までの FizzBuzz リストを生成する。
  """
  def generate_list(count) when is_integer(count) and count > 0 do
    Enum.map(1..count, &generate/1)
  end
end
