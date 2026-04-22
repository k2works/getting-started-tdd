# frozen_string_literal: true

require_relative 'test_helper'
require_relative '../lib/fibonacci/fibonacci'

class FibonacciTest < Minitest::Test
  def setup
    @recursive = Fibonacci::Command.new(Fibonacci::Recursive.new)
    @loop = Fibonacci::Command.new(Fibonacci::Loop.new)
    @general_term = Fibonacci::Command.new(Fibonacci::GeneralTerm.new)
  end

  def test_fibonacci_基本ケース
    cases = [[0, 0], [1, 1], [2, 1], [3, 2], [4, 3], [5, 5]]

    cases.each do |input, expected|
      assert_equal expected, @recursive.exec(input)
      assert_equal expected, @loop.exec(input)
      assert_equal expected, @general_term.exec(input)
    end
  end

  def test_fibonacci_再帰_大きな数
    assert_equal 102_334_155, @recursive.exec(40)
  end

  def test_fibonacci_ループ_大きな数
    assert_equal 102_334_155, @loop.exec(40)
  end

  def test_fibonacci_一般項_大きな数
    assert_equal 102_334_155, @general_term.exec(40)
  end
end
