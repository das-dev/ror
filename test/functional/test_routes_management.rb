# frozen_string_literal: true

require 'minitest/autorun'
require 'minitest/mock'
require_relative '../../lib/main'
require_relative 'helper'

class RoutesManagementTest < Minitest::Test
  def setup
    @helper = TestHelper.new
  end

  def test_create_route
    @helper.scenario_create_station(station_name: 'Origin')
    @helper.scenario_create_station(station_name: 'Destination')
    @helper.scenario_create_route
    @helper.scenario_routes_list
    @helper.scenario_quit

    @helper.run_app

    assert_match(/\nRoute: origin -> destination is created/, @helper.output.string)
    assert_match(/\n1. Route: origin -> destination/, @helper.output.string)
  end
end
