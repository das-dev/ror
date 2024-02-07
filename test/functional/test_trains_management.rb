# frozen_string_literal: true

require 'minitest/autorun'
require 'minitest/mock'
require_relative '../../lib/main'
require_relative 'helper'

class TrainsManagementTest < Minitest::Test
  include Scenarios

  def setup
    @helper = TestHelper.new
  end

  def test_create_train
    scenario_create_train(train_number: '001-01', type: :passenger, manufacturer: 'Golden Wagon')
    scenario_list_train
    scenario_quit

    @helper.run_app

    assert_match(/Passenger train #001-01 is created\n/, @helper.output.string)
    assert_match(/1. Passenger train #001-01\n/, @helper.output.string)
  end

  def test_show_train
    scenario_create_train(train_number: '001-01', type: :passenger, manufacturer: 'Golden Wagon')
    scenario_show_train
    scenario_quit

    @helper.run_app

    expected = /Passenger train #001-01 is at the factory Golden Wagon\nwith 0 carriages\n/
    assert_match(expected, @helper.output.string)
  end

  def test_add_carriage
    scenario_create_train(train_number: '001-01', type: :passenger, manufacturer: 'Golden Wagon')
    scenario_create_passenger_carriage(carriage_number: '100', manufacturer: 'Golden Wagon', seats: '50')
    scenario_add_carriage(train_index: '1', carriage_index: '1')
    scenario_show_train
    scenario_quit

    @helper.run_app

    expected = /Passenger train #001-01 is at the factory Golden Wagon\nwith 1 carriages\n/
    assert_match(expected, @helper.output.string)

    assert_match(/Carriage #100 is attached to passenger train #001-01\n/, @helper.output.string)
  end
end
