defmodule FizzBuzz.StreamConsumer do
  alias FizzBuzz.Streaming

  def first_ten do
    Streaming.lazy_stream()
    |> Enum.take(10)
  end

  def hundredth_value do
    Streaming.lazy_stream()
    |> Enum.at(99)
  end
end
