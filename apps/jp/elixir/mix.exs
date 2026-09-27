defmodule FizzBuzzJp.MixProject do
  use Mix.Project

  def project do
    [
      app: :fizzbuzz_jp,
      version: "0.1.0",
      elixir: "~> 1.18",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  def application do
    [
      extra_applications: [:logger]
    ]
  end

  defp deps do
    [
      # repo.hex.pm に到達できない環境のため、Credo と依存は GitHub から取得する
      {:credo,
       git: "https://github.com/rrrene/credo.git",
       tag: "v1.7.16",
       only: [:dev, :test],
       runtime: false},
      {:bunt,
       git: "https://github.com/rrrene/bunt.git", tag: "v1.0.0", override: true, runtime: false},
      {:file_system,
       git: "https://github.com/falood/file_system.git",
       tag: "v1.1.1",
       override: true,
       runtime: false},
      {:jason,
       git: "https://github.com/michalmuskala/jason.git",
       tag: "v1.4.4",
       override: true,
       runtime: false}
    ]
  end
end
