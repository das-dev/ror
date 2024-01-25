# frozen_string_literal: true

require_relative '../railway_station_manager/railway_station_manager'

# rubocop:disable Style/Documentation
class TestCase
  def initialize
    setup
  end

  def self.run
    new.run
  end

  def setup; end

  def assert_equal(expected, actual)
    raise "Expected #{expected}, got #{actual}" unless expected == actual
  end

  def assert_raises(exception, &block)
    block.call
  rescue exception
    nil
  end
end

module TestStationHelper
  def station
    Station.new('Moscow')
  end

  def train
    Train.new('123', :passenger, 5)
  end
end

module TestRouteHelper
  attr_reader :origin_station, :destination_station,
              :intermediate_station1, :intermediate_station2, :intermediate_station3

  def make_stations
    @origin_station = Station.new('Moskva Oktyabrskaya')
    @intermediate_station1 = Station.new('Tver')
    @intermediate_station2 = Station.new('Vyshniy Volochek')
    @intermediate_station3 = Station.new('Malaya Vishera')
    @destination_station = Station.new('Sankt-Peterburg-Glavn')
  end

  def route
    Route.new(origin_station, destination_station)
  end

  def append_stations(route)
    route.append_intermediate_station(intermediate_station1)
    route.append_intermediate_station(intermediate_station2)
    route.append_intermediate_station(intermediate_station3)
  end

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

module TestTrainHelper
  attr_reader :origin_station, :destination_station

  def make_stations
    @origin_station = Station.new('Moskva Oktyabrskaya')
    @destination_station = Station.new('Sankt-Peterburg-Glavn')
  end

  def reverse_route_train
    Route.new(destination_station, origin_station)
  end

  def train
    Train.new('123', :passenger, 5)
  end

  def route
    Route.new(origin_station, destination_station)
  end
end

class TestStationCase < TestCase
  include TestStationHelper

  def run
    test_name_station
    test_empty_station
    test_add_train
    test_send_train
    test_train_types_stat
  end

  def test_name_station
    station = self.station

    assert_equal 'Moscow', station.name
  end

  def test_empty_station
    station = self.station

    assert_equal [], station.trains
  end

  def test_add_train
    station = self.station
    train = self.train

    station.add_train(train)
    station.add_train(train)

    assert_equal [train], station.trains
  end

  def test_send_train
    station = self.station
    train = self.train
    station.add_train(train)

    station.send_train(train)
    station.send_train(train)

    assert_equal [], station.trains
  end

  def test_train_types_stat
    station = self.station
    train = self.train
    station.add_train(train)

    assert_equal({ passenger: 1 }, station.train_types_stat)
  end
end

class TestRouteCase < TestCase
  include TestRouteHelper

  def run
    test_initial_route_state
    test_intermediate_station_order
    test_append_double_station
    test_remove_intermediate_station
    test_remove_missing_intermediate_station
  end

  def setup
    make_stations
  end

  def test_initial_route_state
    route = self.route

    assert_equal origin_station, route.origin_station
    assert_equal destination_station, route.destination_station
    assert_equal [origin_station, destination_station], route.stations
  end

  def test_intermediate_station_order
    route = self.route

    append_stations(route)

    assert_equal all_stations, route.stations
  end

  def test_append_double_station
    route = self.route

    route.append_intermediate_station(intermediate_station1)
    route.append_intermediate_station(intermediate_station1)

    assert_equal [origin_station, intermediate_station1, destination_station], route.stations
  end

  def test_remove_intermediate_station
    route = self.route
    append_stations(route)

    route.remove_intermediate_station(intermediate_station1)
    route.remove_intermediate_station(intermediate_station3)
    route.remove_intermediate_station(intermediate_station2)

    assert_equal [origin_station, destination_station], route.stations
  end

  def test_remove_missing_intermediate_station
    route = self.route

    route.remove_intermediate_station(origin_station)
    route.remove_intermediate_station(intermediate_station1)

    assert_equal [origin_station, destination_station], route.stations
  end
end

class TestTrainCase < TestCase
  include TestTrainHelper

  def run
    test_initial_train_state
    test_speed_up
    test_speed_down
    test_full_stop
    test_attach_carriage
    test_detach_carriage
    test_carriage_change_while_moving
  end

  def setup
    make_stations
  end

  def test_initial_train_state
    train = self.train

    assert_equal '123', train.number
    assert_equal :passenger, train.type
    assert_equal 5, train.carriage_count
    assert_equal 0, train.speed
    assert_equal nil, train.route
  end

  def test_speed_up
    train = self.train

    train.speed_up(10)

    assert_equal 10, train.speed
  end

  def test_speed_down
    train = self.train

    train.speed_up(10)
    train.speed_down(5)

    assert_equal 5, train.speed
  end

  def test_full_stop
    train = self.train

    train.speed_up(10)
    train.speed_down(15)

    assert_equal 0, train.speed
  end

  def test_attach_carriage
    train = self.train

    train.attach_carriage

    assert_equal 6, train.carriage_count
  end

  def test_detach_carriage
    train = self.train

    train.detach_carriage

    assert_equal 4, train.carriage_count
  end

  def test_carriage_change_while_moving
    train = self.train

    train.speed_up(10)

    assert_raises Exceptions::CarriageChangedWhileMovingError do
      train.attach_carriage
    end
    assert_raises Exceptions::CarriageChangedWhileMovingError do
      train.detach_carriage
    end
  end
end

class TestTrainOnRouteCase < TestCase
  include TestTrainHelper

  # rubocop:disable Metrics/MethodLength
  def run
    test_assign_route
    test_move_forward
    test_move_backward
    test_move_forward_when_last
    test_reassign_route
    test_current_station
    test_current_station_without_route
    test_previous_station
    test_next_station
    test_next_station_when_last
    test_previous_station_when_first
  end
  # rubocop:enable Metrics/MethodLength

  def setup
    make_stations
  end

  def test_assign_route
    train = self.train
    route = self.route

    train.assign_route(route)

    assert_equal route, train.route
    assert_equal origin_station, train.current_station
  end

  def test_move_forward
    train = self.train
    route = self.route
    train.assign_route(route)

    train.move_forward

    assert_equal destination_station, train.current_station
  end

  def test_move_backward
    train = self.train
    route = self.route
    train.assign_route(route)
    train.move_forward

    train.move_backward

    assert_equal origin_station, train.current_station
  end

  def test_move_forward_when_last
    train = self.train
    route = self.route
    train.assign_route(route)
    train.move_forward

    assert_raises Exceptions::NoNextStationError do
      train.move_forward
    end
  end

  def test_reassign_route
    train = self.train
    route = self.route
    train.assign_route(route)
    train.move_forward

    reverse_route_train = self.reverse_route_train
    train.assign_route(reverse_route_train)

    assert_equal reverse_route_train, train.route
  end

  def test_current_station
    train = self.train
    route = self.route
    train.assign_route(route)

    assert_equal origin_station, train.current_station
  end

  def test_current_station_without_route
    train = self.train

    assert_equal nil, train.current_station
  end

  def test_previous_station
    train = self.train
    route = self.route
    train.assign_route(route)
    train.move_forward

    assert_equal origin_station, train.previous_station
  end

  def test_next_station
    train = self.train
    route = self.route
    train.assign_route(route)

    assert_equal destination_station, train.next_station
  end

  def test_next_station_when_last
    train = self.train
    route = self.route
    train.assign_route(route)
    train.move_forward

    assert_equal nil, train.next_station
  end

  def test_previous_station_when_first
    train = self.train
    route = self.route
    train.assign_route(route)

    assert_equal nil, train.previous_station
  end
end
# rubocop:enable all

def runner
  TestRouteCase.run
  TestStationCase.run
  TestTrainCase.run
  TestTrainOnRouteCase.run
rescue StandardError => e
  puts e.backtrace[1]
  puts e.message
else
  puts 'All tests passed!'
end

runner if $PROGRAM_NAME == __FILE__
