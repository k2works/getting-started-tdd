# frozen_string_literal: true

require_relative '../../../test_helper'
require_relative '../../../../lib/fizz_buzz/fizz_buzz'

class FizzBuzzListTest < Minitest::Test
  def test_空リストを生成できる
    list = FizzBuzzList.new
    assert_equal 0, list.size
  end

  def test_addで新しいリストを返す
    list = FizzBuzzList.new
    values = [FizzBuzzValue.new('1', 1)]
    new_list = list.add(values)
    assert_equal 0, list.size
    assert_equal 1, new_list.size
  end

  def test_to_string_arrayで文字列配列を返す
    values = [
      FizzBuzzValue.new('1', 1),
      FizzBuzzValue.new('2', 2),
      FizzBuzzValue.new('Fizz', 3)
    ]
    list = FizzBuzzList.new(values)
    assert_equal %w[1 2 Fizz], list.to_string_array
  end

  def test_上限を超えるとエラー
    values = (1..101).map { |number| FizzBuzzValue.new(number.to_s, number) }
    assert_raises RuntimeError do
      FizzBuzzList.new(values)
    end
  end
end
