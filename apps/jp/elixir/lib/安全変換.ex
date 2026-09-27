defmodule FizzBuzz.Safe do
  @moduledoc "題材 D: 成功と失敗を日本語アトムのタグ付きタプルで表す"

  import FizzBuzz, only: [fizzbuzz_変換: 1]

  @type 変換結果 :: {:成功, String.t()} | {:失敗, String.t()}

  @doc "数値でなければ失敗、0 以下なら失敗、それ以外は FizzBuzz 変換の成功を返す"
  @spec 安全変換(term()) :: 変換結果
  def 安全変換(数) when not is_number(数), do: {:失敗, "数値を指定してください: #{数}"}
  def 安全変換(数) when 数 <= 0, do: {:失敗, "正の数を指定してください: #{数}"}
  def 安全変換(数), do: {:成功, fizzbuzz_変換(数)}
end
