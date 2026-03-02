# frozen_string_literal: true

require 'minitest/autorun'
require 'minitest/benchmark'
require_relative '../../lib/fibonacci/fibonacci'

class FibonacciBenchmark < Minitest::Benchmark
  def setup
    @recursive = Fibonacci::Command.new(Fibonacci::Recursive.new)
    @loop = Fibonacci::Command.new(Fibonacci::Loop.new)
    @general_term = Fibonacci::Command.new(Fibonacci::GeneralTerm.new)
  end

  def bench_recursive
    assert_performance_constant do |_n|
      1000.times { |i| @recursive.exec(i) }
    end
  end

  def bench_loop
    assert_performance_constant do |_n|
      1000.times { |i| @loop.exec(i) }
    end
  end

  def bench_general_term
    assert_performance_constant do |_n|
      1000.times { |i| @general_term.exec(i) }
    end
  end
end
