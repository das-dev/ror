# frozen_string_literal: true

require "minitest/autorun"
require "minitest/mock"
require_relative "../../lib/main"
require_relative "helper"

class GeneralScenariosTest < Minitest::Test
  include Scenarios

  def setup
    @helper = TestHelper.new
  end

  def test_main_menu
    scenario_quit

    @helper.run_app

    assert_equal TestHelper::MAIN_MENU, @helper.output.string
  end

  def test_stat
    scenario_create_route(from: "Origin", to: "Destination")
    scenario_create_train(train_number: "001-00", type: :passenger, manufacturer: "Manufacturer 1")
    scenario_create_train(train_number: "002-00", type: :cargo, manufacturer: "Manufacturer 1")
    scenario_stat
    scenario_quit

    @helper.run_app

    pattern = format(TestHelper::STAT_VIEW, 2, 0, 0, 1, 1, 1)

    assert_match(/#{pattern}/, @helper.output.string)
  end

  def test_trains_on_route
    meta_scenario_create_route_with_trains
    scenario_train_move_on_route(train_index: "1", moves: ["1"] * 4)
    scenario_list_trains_on_station(station_index: "1")
    scenario_list_trains_on_station(station_index: "2")
    scenario_quit

    @helper.run_app

    assert_match(/1. Train #001-01, cargo, 0 carriages\n/, @helper.output.string)
    assert_match(/1. Train #001-00, passenger, 0 carriages\n/, @helper.output.string)
  end
end
