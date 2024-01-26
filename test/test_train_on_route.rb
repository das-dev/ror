# frozen_string_literal: true

require 'minitest/autorun'
require_relative '../railway_station_manager/train'

class TestTrainOnRoute < Minitest::Test
  attr_reader :origin_station, :destination_station,
              :reverse_route_train, :train, :route

  def setup
    @origin_station = Station.new('Moskva Oktyabrskaya')
    @destination_station = Station.new('Sankt-Peterburg-Glavn')

    @reverse_route_train = Route.new(destination_station, origin_station)
    @train = Train.new('123', :passenger, 5)
    @route = Route.new(origin_station, destination_station)
    @train.assign_route(@route)
  end

  def test_assign_route
    assert_equal route, train.route
    assert_equal origin_station, train.current_station
  end

  def test_move_forward
    train.move_forward

    assert_equal destination_station, train.current_station
  end

  def test_move_backward
    train.move_forward
    train.move_backward

    assert_equal origin_station, train.current_station
  end

  def test_move_forward_when_last
    train.move_forward

    assert_raises Train::NoNextStationError do
      train.move_forward
    end
  end

  def test_move_backward_when_first
    assert_raises Train::NoPreviousStationError do
      train.move_backward
    end
  end

  def test_reassign_route
    train.move_forward

    train.assign_route(reverse_route_train)

    assert_equal reverse_route_train, train.route
  end

  def test_current_station
    assert_equal origin_station, train.current_station
  end

  def test_previous_station
    train.move_forward

    assert_equal origin_station, train.previous_station
  end

  def test_next_station
    assert_equal destination_station, train.next_station
  end

  def test_next_station_when_last
    train.move_forward

    assert_nil train.next_station
  end

  def test_previous_station_when_first
    assert_nil train.previous_station
  end
end
