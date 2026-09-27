defmodule :タイプ do
  @moduledoc """
  題材 B: 名前と変換関数を持つタイプ。

  エイリアス（`FizzBuzz.タイプ` など）は ASCII しか使えないため、
  アトムをそのままモジュール名にして `%:タイプ{}` と書く。
  """
  @enforce_keys [:名前, :変換]
  defstruct [:名前, :変換]
end

defmodule :タイプ未定義エラー do
  @moduledoc "存在しないタイプ番号を指定したときの例外"
  defexception [:message]
end

defmodule FizzBuzz.Type do
  @moduledoc "題材 B: タイプの生成と適用"

  import FizzBuzz, only: [fizzbuzz_変換: 1]

  @doc "番号からタイプを生成する"
  def タイプ生成(1), do: %:タイプ{名前: "通常", 変換: &fizzbuzz_変換/1}
  def タイプ生成(2), do: %:タイプ{名前: "数字限定", 変換: &Integer.to_string/1}
  def タイプ生成(3), do: %:タイプ{名前: "FizzBuzz限定", 変換: &fizzbuzz_限定変換/1}

  def タイプ生成(番号) do
    raise :タイプ未定義エラー, "該当するタイプは存在しません: #{番号}"
  end

  @doc "タイプの変換を数に適用する"
  def タイプ変換(%:タイプ{変換: 変換}, 数), do: 変換.(数)

  defp fizzbuzz_限定変換(数) when rem(数, 15) == 0, do: "FizzBuzz"
  defp fizzbuzz_限定変換(数), do: Integer.to_string(数)
end
