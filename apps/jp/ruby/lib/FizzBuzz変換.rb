# frozen_string_literal: true

# 題材 A: FizzBuzz の基本変換
module FizzBuzz基本
  module_function

  def FizzBuzz変換(数)
    return 'FizzBuzz' if (数 % 15).zero?
    return 'Fizz' if (数 % 3).zero?
    return 'Buzz' if (数 % 5).zero?

    数.to_s
  end

  def FizzBuzz配列作成(上限)
    (1..上限).map { FizzBuzz変換(_1) }
  end
end
