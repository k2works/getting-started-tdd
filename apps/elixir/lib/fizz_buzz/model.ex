defmodule FizzBuzz.Model do
  @moduledoc """
  FizzBuzz の値オブジェクトとコレクションモジュール。
  """

  defmodule Value do
    @moduledoc "FizzBuzz の単一値を表す構造体"
    @enforce_keys [:number, :value]
    defstruct [:number, :value]

    @doc "値を文字列として返す"
    def to_string(%__MODULE__{value: value}), do: value
  end

  defmodule List do
    @moduledoc "FizzBuzz のリストを表す構造体"
    @enforce_keys [:values]
    defstruct [:values]

    @doc "値のリストを文字列リストに変換する"
    def to_string_list(%__MODULE__{values: values}) do
      Enum.map(values, &Value.to_string/1)
    end

    @doc "リストの要素数を返す"
    def count(%__MODULE__{values: values}), do: length(values)

    @doc "1 から count までの FizzBuzz リストを生成する"
    def create(count, type) do
      values =
        Enum.map(1..count, fn n ->
          %Value{
            number: n,
            value: FizzBuzz.Type.Generatable.generate(type, n)
          }
        end)

      %__MODULE__{values: values}
    end
  end
end
