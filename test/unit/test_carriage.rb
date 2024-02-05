# frozen_string_literal: true

require 'minitest/autorun'
require_relative '../../lib/model/carriage'

class TestCarriage < Minitest::Test
  attr_reader :cargo_carriage, :passenger_carriage

  def setup
    @passenger_carriage = Carriage.make_carriage(:passenger, number: '123-P', seats: 0)
    @cargo_carriage = Carriage.make_carriage(:cargo, number: '123-C', volume: 0)
  end

  def test_carriage_initial_state
    assert_equal :passenger, passenger_carriage.type
    assert_equal '123-P', passenger_carriage.number

    assert_equal :cargo, cargo_carriage.type
    assert_equal '123-C', cargo_carriage.number
  end

  def test_valid_number_format
    carriage = Carriage.make_carriage(:passenger, number: '123P', seats: 0)

    assert_equal true, carriage.valid?
  end

  def test_invalid_number_format
    assert_raises(ValidationError) do
      Carriage.make_carriage(:cargo, number: '123_P', volume: 0)
    end
  end

  def test_empty_number
    assert_raises(ValidationError) do
      Carriage.make_carriage(:cargo, number: '', volume: 0)
    end
  end
end
