# frozen_string_literal: true

require 'minitest/autorun'
require_relative '../railway_station_manager/carriage'

class TestCarriage < Minitest::Test
  attr_reader :carriage

  def test_carriage_type
    assert_equal :passenger, Carriage.new(:passenger).type
    assert_equal :cargo, Carriage.new(:cargo).type
  end
end
