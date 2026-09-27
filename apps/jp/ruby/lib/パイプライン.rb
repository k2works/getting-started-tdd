# frozen_string_literal: true

require 'FizzBuzz変換'

# 題材 C: 不変データとパイプライン処理
module FizzBuzzパイプライン
  module_function

  def 装飾(文字列)
    "[#{文字列}]"
  end

  # 「N を FizzBuzz変換して 装飾して 戻す」を Method#>> の合成で左から右へ
  def FizzBuzz装飾(数)
    (FizzBuzz基本.method(:FizzBuzz変換) >> method(:装飾)).call(数)
  end

  def パイプライン処理(上限)
    (1..上限).map { FizzBuzz装飾(_1) }.freeze
  end
end
