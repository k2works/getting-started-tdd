# frozen_string_literal: true

require_relative 'test_helper'
require_relative '../lib/fibonacci/fibonacci'
require 'minitest/benchmark'

class FibonacciBenchmark < Minitest::Benchmark
  def setup
    @recursive = Fibonacci::Command.new(Fibonacci::Recursive.new)
    @loop = Fibonacci::Command.new(Fibonacci::Loop.new)
    @general_term = Fibonacci::Command.new(Fibonacci::GeneralTerm.new)
  end

  def bench_recursive
    assert_performance_constant do |_number|
      1000.times { |index| @recursive.exec(index) }
    end
  end

  def bench_loop
    assert_performance_constant do |_number|
      1000.times { |index| @loop.exec(index) }
    end
  end

  def bench_general_term
    assert_performance_constant do |_number|
      1000.times { |index| @general_term.exec(index) }
    end
  end
end
