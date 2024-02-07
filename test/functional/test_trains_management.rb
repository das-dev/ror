# frozen_string_literal: true

require 'minitest/autorun'
require 'minitest/mock'
require_relative '../../lib/main'
require_relative 'helper'

# rubocop:disable Metrics/MethodLength
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
    assert_match(/1. Train #001-01, passenger, 0 carriages\n/, @helper.output.string)
  end

  def test_show_train
    scenario_create_train(train_number: '001-01', type: :passenger, manufacturer: 'Golden Wagon')
    scenario_show_train
    scenario_quit

    @helper.run_app

    expected = /Passenger train #001-01 is at the factory Golden Wagon\nNo carriages\n/
    assert_match(expected, @helper.output.string)
  end

  def test_add_carriage
    scenario_create_train(train_number: '001-01', type: :passenger, manufacturer: 'Golden Wagon')

    scenario_create_passenger_carriage(carriage_number: '100', manufacturer: 'Golden Wagon', seats: '50')
    scenario_create_passenger_carriage(carriage_number: '101', manufacturer: 'American Railroads', seats: '50')
    scenario_create_cargo_carriage(carriage_number: '3000-A', manufacturer: 'Cargo Cult', volume: '35')

    scenario_add_carriage(train_index: '1', carriage_index: '1')
    scenario_add_carriage(train_index: '1', carriage_index: '1')
    scenario_add_carriage(train_index: '1', carriage_index: '2')
    scenario_add_carriage(train_index: '1', carriage_index: '3')

    scenario_show_train
    scenario_quit

    @helper.run_app

    expected = <<~EXPECTED
      Passenger train #001-01 is at the factory Golden Wagon
        1. Carriage #100, passenger, 50 free seats, 0 occupied seats
        2. Carriage #101, passenger, 50 free seats, 0 occupied seats
    EXPECTED
    assert_match(/#{expected}/, @helper.output.string)
  end
end
# rubocop:enable all
