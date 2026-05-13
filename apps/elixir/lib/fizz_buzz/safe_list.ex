defmodule FizzBuzz.SafeList do
  alias FizzBuzz.Safe

  def safe_generate_list(inputs) when is_list(inputs) do
    inputs
    |> Enum.reduce_while({:ok, []}, fn input, {:ok, acc} ->
      with {:ok, value} <- Safe.safe_generate(input) do
        {:cont, {:ok, acc ++ [value]}}
      else
        {:error, reason} -> {:halt, {:error, {:invalid_item, input, reason}}}
      end
    end)
  end

  def safe_generate_list(_), do: {:error, :not_list}
end
