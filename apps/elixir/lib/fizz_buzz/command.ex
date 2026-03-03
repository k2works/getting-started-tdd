defmodule FizzBuzz.Command do
  @moduledoc """
  FizzBuzz のコマンドパターンモジュール。
  ビヘイビアを使ったインターフェース定義。
  """

  @callback execute() :: any()

  defmodule ValueCommand do
    @moduledoc "単一値の FizzBuzz コマンド"
    @behaviour FizzBuzz.Command

    defstruct [:number, :type]

    @impl true
    def execute do
      execute(%__MODULE__{number: 1, type: %FizzBuzz.Type.Type01{}})
    end

    def execute(%__MODULE__{number: number, type: type}) do
      value = FizzBuzz.Type.Generatable.generate(type, number)
      %FizzBuzz.Model.Value{number: number, value: value}
    end
  end

  defmodule ListCommand do
    @moduledoc "リストの FizzBuzz コマンド"
    @behaviour FizzBuzz.Command

    defstruct [:count, :type]

    @impl true
    def execute do
      execute(%__MODULE__{count: 100, type: %FizzBuzz.Type.Type01{}})
    end

    def execute(%__MODULE__{count: count, type: type}) do
      FizzBuzz.Model.List.create(count, type)
    end
  end
end
