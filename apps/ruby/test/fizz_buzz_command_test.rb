# frozen_string_literal: true

require_relative 'test_helper'
require_relative '../lib/fizz_buzz/fizz_buzz'

class FizzBuzzCommandTest < Minitest::Test
  def test_FizzBuzzValueCommandは単一の値を生成する
    type = FizzBuzzType.create(FizzBuzzType::TYPE_01)
    command = FizzBuzzValueCommand.new(type, 3)
    result = command.execute

    assert_equal 'Fizz', result.to_s
  end

  def test_FizzBuzzListCommandはリストを生成する
    type = FizzBuzzType.create(FizzBuzzType::TYPE_01)
    command = FizzBuzzListCommand.new(type, 100)
    result = command.execute
    array = result.to_string_array

    assert_equal 100, result.size
    assert_equal 'Fizz', array[2]
    assert_equal 'Buzz', array[4]
    assert_equal 'FizzBuzz', array[14]
  end

  def test_デフォルトで100件のリストを生成する
    type = FizzBuzzType.create(FizzBuzzType::TYPE_01)
    command = FizzBuzzListCommand.new(type)
    result = command.execute

    assert_equal 100, result.size
  end
end
