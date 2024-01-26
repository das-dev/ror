# frozen_string_literal: true

require 'minitest/autorun'
require_relative '../railway_station_manager/railway_station_manager'

class TestStation < Minitest::Test
  attr_reader :train, :station

  def setup
    @train = Train.new('123', :passenger, 5)
    @station = Station.new('Moscow')
  end

  def test_name_station
    assert_equal 'Moscow', station.name
  end

  def test_empty_station
    assert_equal [], station.trains
  end

  def test_add_train
    station.add_train(train)
    station.add_train(train)

    assert_equal [train], station.trains
  end

  def test_send_train
    station.add_train(train)

    station.send_train(train)
    station.send_train(train)

    assert_equal [], station.trains
  end

  def test_train_types_stat
    station.add_train(train)

    assert_equal({ passenger: 1 }, station.train_types_stat)
  end
end
