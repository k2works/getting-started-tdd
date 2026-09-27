# frozen_string_literal: true

require 'FizzBuzz変換'

# 定数は大文字始まりが必須のため、全角大文字 Ｔ を前置する
Ｔタイプ = Data.define(:名前, :変換)

# 題材 B: タイプ別の変換（Proc を格納した Data によるポリモーフィズム）
module FizzBuzzタイプ
  module_function

  def タイプ生成(番号)
    case 番号
    when 1 then Ｔタイプ.new(名前: '通常', 変換: FizzBuzz基本.method(:FizzBuzz変換))
    when 2 then Ｔタイプ.new(名前: '数字限定', 変換: :to_s.to_proc)
    when 3 then Ｔタイプ.new(名前: 'FizzBuzz限定', 変換: ->(数) { (数 % 15).zero? ? 'FizzBuzz' : 数.to_s })
    else raise ArgumentError, "該当するタイプは存在しません: #{番号}"
    end
  end

  def タイプ変換(タイプ, 数)
    タイプ.変換.call(数)
  end
end
