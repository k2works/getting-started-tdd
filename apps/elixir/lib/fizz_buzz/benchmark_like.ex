defmodule FizzBuzz.BenchmarkLike do
  def compare(limit) do
    {eager_us, _} =
      :timer.tc(fn ->
        1..limit
        |> Enum.map(&heavy_work/1)
        |> Enum.take(10)
      end)

    {lazy_us, _} =
      :timer.tc(fn ->
        1..limit
        |> Stream.map(&heavy_work/1)
        |> Enum.take(10)
      end)

    %{eager_us: eager_us, lazy_us: lazy_us}
  end

  defp heavy_work(n) do
    if rem(n, 15) == 0, do: "FizzBuzz", else: Integer.to_string(n)
  end
end
