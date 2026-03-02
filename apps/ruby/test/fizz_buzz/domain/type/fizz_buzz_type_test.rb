# frozen_string_literal: true

require_relative '../../../test_helper'
require_relative '../../../../lib/fizz_buzz/fizz_buzz'

class FizzBuzzTypeTest < Minitest::Test
  describe 'タイプ1の場合' do
    def setup
      @type = FizzBuzzType.create(FizzBuzzType::TYPE_01)
    end

    def test_1を渡したら文字列1を返す
      assert_equal '1', @type.generate(1).to_s
    end

    def test_3を渡したらFizzを返す
      assert_equal 'Fizz', @type.generate(3).to_s
    end

    def test_5を渡したらBuzzを返す
      assert_equal 'Buzz', @type.generate(5).to_s
    end

    def test_15を渡したらFizzBuzzを返す
      assert_equal 'FizzBuzz', @type.generate(15).to_s
    end
  end

  describe 'タイプ2の場合' do
    def setup
      @type = FizzBuzzType.create(FizzBuzzType::TYPE_02)
    end

    def test_3を渡したら文字列3を返す
      assert_equal '3', @type.generate(3).to_s
    end

    def test_15を渡したら文字列15を返す
      assert_equal '15', @type.generate(15).to_s
    end
  end

  describe 'タイプ3の場合' do
    def setup
      @type = FizzBuzzType.create(FizzBuzzType::TYPE_03)
    end

    def test_3を渡したら文字列3を返す
      assert_equal '3', @type.generate(3).to_s
    end

    def test_15を渡したらFizzBuzzを返す
      assert_equal 'FizzBuzz', @type.generate(15).to_s
    end
  end

  describe 'ファクトリメソッド' do
    def test_TYPE_01を指定するとFizzBuzzType01が返る
      type = FizzBuzzType.create(FizzBuzzType::TYPE_01)
      assert_instance_of FizzBuzzType01, type
    end

    def test_未定義のタイプを指定するとエラーが発生する
      assert_raises RuntimeError do
        FizzBuzzType.create(99)
      end
    end
  end
end
