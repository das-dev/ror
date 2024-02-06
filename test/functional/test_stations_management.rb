# frozen_string_literal: true

require 'minitest/autorun'
require 'minitest/mock'
require_relative '../../lib/main'
require_relative 'helper'

class StationsManagementTest < Minitest::Test
  include Scenarios

  def setup
    @helper = TestHelper.new
  end

  def test_create_station
    scenario_create_station(station_name: 'Origin')
    scenario_create_station(station_name: 'Destination')
    scenario_list_station
    scenario_quit

    @helper.run_app

    assert_match(/Station "Origin" is created\n/, @helper.output.string)
    assert_match(/1. Station "Origin"\n/, @helper.output.string)

    assert_match(/Station "Destination" is created\n/, @helper.output.string)
    assert_match(/2. Station "Destination"\n/, @helper.output.string)
  end
end
