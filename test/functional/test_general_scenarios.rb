# frozen_string_literal: true

require 'minitest/autorun'
require 'minitest/mock'
require_relative '../../lib/main'
require_relative 'helper'

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
    scenario_create_station(station_name: 'Station1')
    scenario_create_station(station_name: 'Station2')
    scenario_create_train(train_number: '001-00', type: :passenger, manufacturer: 'Manufacturer1')
    scenario_create_train(train_number: '002-00', type: :cargo, manufacturer: 'Manufacturer1')
    scenario_create_route
    scenario_stat
    scenario_quit

    @helper.run_app

    pattern = format(TestHelper::STAT_VIEW, 2, 1, 1, 1)
    assert_match(/#{pattern}/, @helper.output.string)
  end
end
