# frozen_string_literal: true

require 'minitest/autorun'
require_relative '../lib/model/carriage'

class TestCarriage < Minitest::Test
  attr_reader :cargo_carriage, :passenger_carriage

  def setup
    @passenger_carriage = Carriage.new(:passenger, '123-P')
    @cargo_carriage = Carriage.new(:cargo, '123-C')
  end

  def test_carriage_initial_state
    assert_equal :passenger, passenger_carriage.type
    assert_equal '123-P', passenger_carriage.number

    assert_equal :cargo, cargo_carriage.type
    assert_equal '123-C', cargo_carriage.number
  end
end
