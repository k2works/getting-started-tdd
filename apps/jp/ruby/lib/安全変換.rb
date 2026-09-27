# frozen_string_literal: true

require 'FizzBuzz変換'

# 題材 D: 変換結果（成功・失敗）を値として返す
Ｒ変換結果 = Data.define(:成功?, :値, :エラー) do
  def self.成功(値) = new(成功?: true, 値:, エラー: nil)
  def self.失敗(エラー) = new(成功?: false, 値: nil, エラー:)
end

# 題材 D: 例外を使わない安全な変換
module FizzBuzz安全変換
  module_function

  def 安全変換(数)
    return Ｒ変換結果.失敗("数値を指定してください: #{数}") unless 数.is_a?(Integer)
    return Ｒ変換結果.失敗("正の数を指定してください: #{数}") unless 数.positive?

    Ｒ変換結果.成功(FizzBuzz基本.FizzBuzz変換(数))
  end
end
