# frozen_string_literal: true

require 'test_helper'
require 'FizzBuzz変換'

class FizzBuzz変換テスト < Minitest::Test
  include FizzBuzz基本

  def test_3を渡したらFizzを返す
    assert_equal 'Fizz', FizzBuzz変換(3)
  end

  def test_5を渡したらBuzzを返す
    assert_equal 'Buzz', FizzBuzz変換(5)
  end

  def test_15を渡したらFizzBuzzを返す
    assert_equal 'FizzBuzz', FizzBuzz変換(15)
  end

  def test_1を渡したら文字列1を返す
    assert_equal '1', FizzBuzz変換(1)
  end

  def test_2を渡したら文字列2を返す
    assert_equal '2', FizzBuzz変換(2)
  end

  def test_15まで作ると15件になる
    assert_equal 15, FizzBuzz配列作成(15).size
  end

  def test_15まで作った配列の並び
    assert_equal '1,2,Fizz,4,Buzz,Fizz,7,8,Fizz,Buzz,11,Fizz,13,14,FizzBuzz',
                 FizzBuzz配列作成(15).join(',')
  end
end
