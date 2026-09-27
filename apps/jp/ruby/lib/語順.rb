# frozen_string_literal: true

require 'FizzBuzz変換'
require 'パイプライン'

# 語順の再現: Integer と String を refinement で開き「3.FizzBuzz変換」と後置で書く
module FizzBuzz語順
  refine Integer do
    # 助詞「を」に相当する何もしないメソッド。3.を.FizzBuzz変換 と書ける
    def を = self

    def FizzBuzz変換 = FizzBuzz基本.FizzBuzz変換(self)
  end

  refine String do
    def 装飾 = FizzBuzzパイプライン.装飾(self)
  end
end
