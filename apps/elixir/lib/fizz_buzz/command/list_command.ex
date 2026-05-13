defmodule FizzBuzz.Command.ListCommand do
  @behaviour FizzBuzz.Command

  alias FizzBuzz.FizzBuzzService

  @impl true
  def run(limit) when is_integer(limit) and limit > 0 do
    values =
      1..limit
      |> Enum.map(&FizzBuzzService.generate/1)

    {:ok, values}
  end

  @impl true
  def run(_), do: {:error, :invalid_limit}
end
