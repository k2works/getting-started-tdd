# frozen_string_literal: true

require_relative '../../../test_helper'
require_relative '../../../../lib/fizz_buzz/fizz_buzz'

class FizzBuzzValueTest < Minitest::Test
  def test_値と数値を保持する
    value = FizzBuzzValue.new('Fizz', 3)
    assert_equal 'Fizz', value.value
    assert_equal 3, value.number
  end

  def test_to_stringは値を返す
    value = FizzBuzzValue.new('Buzz', 5)
    assert_equal 'Buzz', value.to_s
  end

  def test_同じ値と数値の場合equalはtrue
    value1 = FizzBuzzValue.new('Fizz', 3)
    value2 = FizzBuzzValue.new('Fizz', 3)
    assert_equal value1, value2
  end

  def test_異なる値の場合equalはfalse
    value1 = FizzBuzzValue.new('Fizz', 3)
    value2 = FizzBuzzValue.new('Buzz', 5)
    refute_equal value1, value2
  end

  def test_負の値はエラー
    assert_raises ArgumentError do
      FizzBuzzValue.new('Fizz', -1)
    end
  end
end
