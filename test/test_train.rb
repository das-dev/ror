# frozen_string_literal: true

require 'minitest/autorun'
require_relative '../railway_station_manager/train'

class TestTrain < Minitest::Test
  attr_reader :origin, :destination, :reverse_route_train, :train, :route

  def setup
    @origin = Struct.new
    @destination = Struct.new

    @train = Train.new('123', :passenger)
  end

  def test_initial_train_state
    assert_equal '123', train.number
    assert_equal :passenger, train.type
    assert_equal 0, train.carriage_count
    assert_equal 0, train.speed
    assert_nil train.route
  end

  def test_speed_up
    train.speed_up(10)

    assert_equal 10, train.speed
  end

  def test_speed_down
    train.speed_up(10)
    train.speed_down(5)

    assert_equal 5, train.speed
  end

  def test_full_stop
    train.speed_up(10)
    train.speed_down(15)

    assert_equal 0, train.speed
  end

  def test_attach_carriage
    train.attach_carriage(Struct.new)
    train.attach_carriage(Struct.new)
    train.attach_carriage(Struct.new)

    assert_equal 3, train.carriage_count
  end

  def test_detach_carriage
    train.attach_carriage(Struct.new)
    train.attach_carriage(Struct.new)
    train.attach_carriage(Struct.new)
    train.detach_carriage

    assert_equal 2, train.carriage_count
  end

  def test_carriage_change_while_moving
    train.attach_carriage(Struct.new)
    train.speed_up(10)

    assert_raises Train::CarriageChangedWhileMovingError do
      train.attach_carriage(Struct.new)
    end
    assert_raises Train::CarriageChangedWhileMovingError do
      train.detach_carriage
    end
  end

  def test_current_station_without_route
    assert_nil train.current_station
  end
end
