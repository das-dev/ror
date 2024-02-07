# frozen_string_literal: true

require 'minitest/autorun'
require_relative '../../lib/model/route'

class TestRoute < Minitest::Test
  attr_reader :route, :origin, :destination, :intermediate1, :intermediate2, :intermediate3

  def setup
    @origin = Struct.new(:name).new('origin')
    @intermediate1 = Struct.new(:name).new('intermediate1')
    @intermediate2 = Struct.new(:name).new('intermediate2')
    @intermediate3 = Struct.new(:name).new('intermediate3')
    @destination = Struct.new(:name).new('destination')

    @route = Route.new(@origin, @destination)
  end

  def test_initial_route_state
    assert_equal origin, route.origin_station
    assert_equal destination, route.destination_station
    assert_equal [origin, destination], route.stations
  end

  def test_same_stations_error
    assert_raises(ValidationError) { Route.new(origin, origin) }
  end

  def test_intermediate_station_order
    route.append_intermediate_station(intermediate1)
    route.append_intermediate_station(intermediate2)
    route.append_intermediate_station(intermediate3)

    assert_equal all_stations, route.stations
  end

  def test_append_intermediate_station
    route.append_intermediate_station(intermediate1)

    assert_equal [origin, intermediate1, destination], route.stations
  end

  def test_append_double_station_without_effect
    route.append_intermediate_station(intermediate1)
    route.append_intermediate_station(intermediate1)

    assert_equal [origin, intermediate1, destination], route.stations
  end

  def test_remove_intermediate_station
    route.append_intermediate_station(intermediate1)

    route.remove_intermediate_station(intermediate1)

    assert_equal [origin, destination], route.stations
  end

  def remove_intermediate_station_without_effect
    route.remove_intermediate_station(origin)
    route.remove_intermediate_station(intermediate1)
    route.remove_intermediate_station(intermediate1)

    assert_equal [origin, destination], route.stations
  end

  private

  def all_stations
    [origin, intermediate1, intermediate2, intermediate3, destination]
  end
end
