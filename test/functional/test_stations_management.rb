# frozen_string_literal: true

require 'minitest/autorun'
require 'minitest/mock'
require_relative '../../lib/main'
require_relative 'helper'

class StationsManagementTest < Minitest::Test
  def setup
    @helper = TestHelper.new
  end

  def test_create_station
    @helper.scenario_create_station(station_name: 'Origin')
    @helper.scenario_create_station(station_name: 'Destination')
    @helper.scenario_list_station
    @helper.scenario_quit

    @helper.run_app

    assert_match(/\nStation "origin" is created/, @helper.output.string)
    assert_match(/\n1. Station "origin"/, @helper.output.string)

    assert_match(/\nStation "destination" is created/, @helper.output.string)
    assert_match(/\n2. Station "destination"/, @helper.output.string)
  end
end
