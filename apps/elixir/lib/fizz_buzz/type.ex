defmodule FizzBuzz.Type do
  @moduledoc """
  FizzBuzz のタイプ定義モジュール。
  プロトコルを使ったポリモーフィズムを実現する。
  """

  defprotocol Generatable do
    @doc "数値を FizzBuzz 文字列に変換する"
    def generate(type, number)
  end

  defmodule Type01 do
    @moduledoc "タイプ 1: 通常の FizzBuzz"
    defstruct []

    defimpl FizzBuzz.Type.Generatable do
      def generate(_type, number) do
        cond do
          rem(number, 15) == 0 -> "FizzBuzz"
          rem(number, 3) == 0 -> "Fizz"
          rem(number, 5) == 0 -> "Buzz"
          true -> Integer.to_string(number)
        end
      end
    end
  end

  defmodule Type02 do
    @moduledoc "タイプ 2: 3 の倍数のみ変換"
    defstruct []

    defimpl FizzBuzz.Type.Generatable do
      def generate(_type, number) do
        if rem(number, 3) == 0 do
          Integer.to_string(number)
        else
          Integer.to_string(number)
        end
      end
    end
  end

  defmodule Type03 do
    @moduledoc "タイプ 3: FizzBuzz に加えて 15 の倍数で特殊出力"
    defstruct []

    defimpl FizzBuzz.Type.Generatable do
      def generate(_type, number) do
        cond do
          rem(number, 15) == 0 -> "FizzBuzz"
          rem(number, 3) == 0 -> "Fizz"
          rem(number, 5) == 0 -> "Buzz"
          true -> Integer.to_string(number)
        end
      end
    end
  end

  @doc """
  タイプ番号からタイプ構造体を生成する。
  """
  def create(1), do: {:ok, %Type01{}}
  def create(2), do: {:ok, %Type02{}}
  def create(3), do: {:ok, %Type03{}}
  def create(_), do: {:error, "未定義のタイプです"}
end
