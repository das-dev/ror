# frozen_string_literal: true

require "minitest/autorun"
require "minitest/mock"
require_relative "../../lib/main"
require_relative "helper"

class RoutesManagementTest < Minitest::Test
  include Scenarios

  def setup
    @helper = TestHelper.new
  end

  def test_create_route
    scenario_create_route(from: "Origin", to: "Destination")
    scenario_routes_list
    scenario_quit

    @helper.run_app

    assert_match(/Route: Origin -> Destination is created\n/, @helper.output.string)
    assert_match(/1. Route: Origin -> Destination\n/, @helper.output.string)
  end
end
