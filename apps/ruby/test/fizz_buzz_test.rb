# frozen_string_literal: true

require_relative 'test_helper'
require_relative '../lib/fizz_buzz'

class FizzBuzzTest < Minitest::Test
  def setup
    @fizzbuzz = FizzBuzz
  end

  def test_1を渡したら文字列1を返す
    assert_equal '1', @fizzbuzz.generate(1)
  end

  def test_2を渡したら文字列2を返す
    assert_equal '2', @fizzbuzz.generate(2)
  end

  def test_3を渡したらFizzを返す
    assert_equal 'Fizz', @fizzbuzz.generate(3)
  end

  def test_5を渡したらBuzzを返す
    assert_equal 'Buzz', @fizzbuzz.generate(5)
  end

  def test_15を渡したらFizzBuzzを返す
    assert_equal 'FizzBuzz', @fizzbuzz.generate(15)
  end

  def test_1から100までの数の配列を返す
    result = @fizzbuzz.generate_list
    assert_equal 100, result.length
    assert_equal '1', result[0]
    assert_equal '2', result[1]
    assert_equal 'Fizz', result[2]
    assert_equal '4', result[3]
    assert_equal 'Buzz', result[4]
    assert_equal 'FizzBuzz', result[14]
  end
end
