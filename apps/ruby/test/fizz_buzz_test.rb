require_relative 'test_helper'
require_relative '../lib/fizz_buzz'

class FizzBuzzTest < Minitest::Test
  def setup
    @fizzbuzz = FizzBuzz
  end
 
  def test_1を渡したら文字列1を返す
    assert_equal '1', @fizzbuzz.generate(1)
  end
end
