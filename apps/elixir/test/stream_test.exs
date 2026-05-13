defmodule FizzBuzz.StreamTest do
  use ExUnit.Case, async: true

  alias FizzBuzz.{BenchmarkLike, StreamConsumer, Streaming}

  test "lazy_stream/0 から先頭 5 件を取り出せる" do
    assert Streaming.lazy_stream() |> Enum.take(5) == ["1", "2", "Fizz", "4", "Buzz"]
  end

  test "Enum.at/2 で任意位置を取得できる" do
    assert StreamConsumer.hundredth_value() == "Buzz"
  end

  test "無限ストリームでも take で安全に扱える" do
    result = Streaming.lazy_stream() |> Enum.take(15)
    assert Enum.at(result, 14) == "FizzBuzz"
  end

  test "遅延評価は先頭だけ必要な処理で有利になりやすい" do
    times = BenchmarkLike.compare(50_000)

    assert is_integer(times.eager_us)
    assert is_integer(times.lazy_us)
    assert times.lazy_us <= times.eager_us
  end
end
