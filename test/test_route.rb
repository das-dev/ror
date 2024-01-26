# frozen_string_literal: true

require 'minitest/autorun'
require_relative '../railway_station_manager/route'

class TestRoute < Minitest::Test
  attr_reader :route, :origin_station, :destination_station,
              :intermediate_station1, :intermediate_station2, :intermediate_station3

  def setup
    @origin_station = Station.new('origin_station')
    @intermediate_station1 = Station.new('intermediate_station1')
    @intermediate_station2 = Station.new('intermediate_station2')
    @intermediate_station3 = Station.new('intermediate_station3')
    @destination_station = Station.new('destination_station')

    @route = Route.new(origin_station, destination_station)
  end

  def test_initial_route_state
    assert_equal origin_station, route.origin_station
    assert_equal destination_station, route.destination_station
    assert_equal [origin_station, destination_station], route.stations
  end

  def test_intermediate_station_order
    route.append_intermediate_station(intermediate_station1)
    route.append_intermediate_station(intermediate_station2)
    route.append_intermediate_station(intermediate_station3)

    assert_equal all_stations, route.stations
  end

  def test_append_double_station
    route.append_intermediate_station(intermediate_station1)
    route.append_intermediate_station(intermediate_station1)

    assert_equal [origin_station, intermediate_station1, destination_station], route.stations
  end

  def test_remove_intermediate_station
    route.append_intermediate_station(intermediate_station1)
    route.append_intermediate_station(intermediate_station2)

    route.remove_intermediate_station(intermediate_station1)
    route.remove_intermediate_station(intermediate_station2)

    assert_equal [origin_station, destination_station], route.stations
  end

  def test_remove_missing_intermediate_station
    route.remove_intermediate_station(origin_station)
    route.remove_intermediate_station(intermediate_station1)

    assert_equal [origin_station, destination_station], route.stations
  end

  private

  def all_stations
    [
      origin_station,
      intermediate_station1,
      intermediate_station2,
      intermediate_station3,
      destination_station
    ]
  end

end
