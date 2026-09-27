# frozen_string_literal: true

require 'test_helper'
require '安全変換'

describe '安全変換' do
  include FizzBuzz安全変換

  it '正の数は成功になる' do
    結果 = 安全変換(3)
    _(結果.成功?).must_equal true
    _(結果.値).must_equal 'Fizz'
  end

  it '0は失敗になる' do
    結果 = 安全変換(0)
    _(結果.成功?).must_equal false
    _(結果.エラー).must_equal '正の数を指定してください: 0'
  end

  it '数値でなければ失敗になる' do
    結果 = 安全変換('a')
    _(結果.成功?).must_equal false
    _(結果.エラー).must_equal '数値を指定してください: a'
  end
end
