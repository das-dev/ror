# frozen_string_literal: true

require 'minitest/autorun'
require_relative '../../lib/model/station'

class TestStation < Minitest::Test
  attr_reader :station

  def setup
    @station = Station.new('Station')
  end

  def test_station_name_validation_with_empty_number_failed
    assert_raises(ValidationError) { Station.new('') }
  end

  def test_station_name_validation_wrong_length_failed
    assert_raises(ValidationError) { Station.new('AB') }
  end

  def test_name_station
    assert_equal 'Station', station.name
  end

  def test_empty_station
    assert_equal [], station.trains
  end

  def test_add_train
    train = Object.new

    station << train
    station << train

    assert_equal [train], station.trains
  end

  def test_send_train
    train = Object.new

    station << train

    station.send_train(train)
    station.send_train(train)

    assert_equal [], station.trains
  end

  def test_train_types_stat_with_empty_station
    assert_equal({}, station.train_types_stat)
  end

  def test_train_types_stat_use_train_type
    train = Minitest::Mock.new
    train.expect(:type, :passenger)

    station << train
    station.train_types_stat

    train.verify
  end

  def test_train_types_stat_with_same_trains
    station << Struct.new(:type).new(:passenger)
    station << Struct.new(:type).new(:passenger)
    station << Struct.new(:type).new(:passenger)

    assert_equal({ passenger: 3 }, station.train_types_stat)
  end

  def test_train_types_stat_with_different_trains
    station << Struct.new(:type).new(:passenger)
    station << Struct.new(:type).new(:cargo)

    assert_equal({ passenger: 1, cargo: 1 }, station.train_types_stat)
  end
end
