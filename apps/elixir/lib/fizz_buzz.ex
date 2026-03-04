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

  @doc """
  カスタムルール関数で生成する。
  """
  def generate_with(number, rule) when is_function(rule, 1) do
    rule.(number)
  end

  @doc """
  リストの各要素を変換関数で変換する。
  """
  def transform(list, func) when is_list(list) and is_function(func, 1) do
    Enum.map(list, func)
  end

  @doc """
  条件に合う要素を抽出する。
  """
  def filter(list, predicate) when is_list(list) and is_function(predicate, 1) do
    Enum.filter(list, predicate)
  end

  @doc """
  2 つの関数を合成する。
  """
  def compose(f, g) when is_function(f, 1) and is_function(g, 1) do
    fn x -> x |> f.() |> g.() end
  end

  @doc """
  安全な生成（正の整数のみ）。
  """
  def safe_generate(number) when is_integer(number) and number > 0 do
    {:ok, generate(number)}
  end

  def safe_generate(_number) do
    {:error, "正の整数を指定してください"}
  end

  @doc """
  FizzBuzz の遅延ストリームを生成する。
  """
  def lazy_stream do
    Stream.iterate(1, &(&1 + 1))
    |> Stream.map(&generate/1)
  end

  @doc """
  with 構文を使った安全な一括処理。
  """
  def safe_generate_list(count) do
    with {:ok, validated} <- validate_count(count),
         result <- generate_list(validated) do
      {:ok, result}
    end
  end

  defp validate_count(count) when is_integer(count) and count > 0 do
    {:ok, count}
  end

  defp validate_count(_count) do
    {:error, "正の整数を指定してください"}
  end
end
