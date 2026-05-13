defmodule FizzBuzz.Command.ValueCommand do
  @behaviour FizzBuzz.Command

  alias FizzBuzz.FizzBuzzService

  @impl true
  def run(number) when is_integer(number) and number > 0 do
    {:ok, FizzBuzzService.generate(number)}
  end

  @impl true
  def run(_), do: {:error, :invalid_number}
end
