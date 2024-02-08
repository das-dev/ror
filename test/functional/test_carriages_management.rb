# frozen_string_literal: true

require "minitest/autorun"
require "minitest/mock"
require_relative "../../lib/main"
require_relative "helper"

class CarriagesManagementTest < Minitest::Test
  include Scenarios

  def setup
    @helper = TestHelper.new
  end

  # TODO: refactor this tests
  # rubocop:disable Metrics/MethodLength
  def test_create_carriages
    scenario_create_passenger_carriage(carriage_number: "100", manufacturer: "Golden Wagon",
                                       seats: "50")
    scenario_create_cargo_carriage(carriage_number: "3000-A", manufacturer: "Cargo Cult",
                                   volume: "35")
    scenario_list_carriages
    scenario_quit

    @helper.run_app

    assert_match(/Passenger carriage #100 is created\n/, @helper.output.string)
    assert_match(/1. Carriage #100, passenger, 50 free seats, 0 occupied seats\n/,
                 @helper.output.string)
    assert_match(/2. Carriage #3000-A, cargo, 35 free volume, 0 occupied volume\n/,
                 @helper.output.string)
  end

  # rubocop:disable Metrics/AbcSize
  def test_add_carriage
    scenario_create_train(train_number: "001-01", type: :passenger, manufacturer: "Golden Wagon")

    scenario_create_passenger_carriage(carriage_number: "100",
                                       manufacturer: "Golden Wagon",
                                       seats: "50")
    scenario_create_passenger_carriage(carriage_number: "101",
                                       manufacturer: "American Railroads",
                                       seats: "50")
    scenario_create_cargo_carriage(carriage_number: "3000-A",
                                   manufacturer: "Cargo Cult",
                                   volume: "35")

    scenario_add_carriage(train_index: "1", carriage_index: "1")
    scenario_add_carriage(train_index: "1", carriage_index: "1")
    scenario_add_carriage(train_index: "1", carriage_index: "2")
    scenario_add_carriage(train_index: "1", carriage_index: "3")

    scenario_show_train
    scenario_quit

    @helper.run_app

    expected = <<~EXPECTED
      Passenger train #001-01 is at the factory Golden Wagon
        1. Carriage #100, passenger, 50 free seats, 0 occupied seats
        2. Carriage #101, passenger, 50 free seats, 0 occupied seats
    EXPECTED
    assert_match(/#{expected}/, @helper.output.string)
    assert_match(/Carriage #100 is attached to passenger train #001-01\n/, @helper.output.string)
  end
  # rubocop:enable all
end
