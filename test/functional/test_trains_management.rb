# frozen_string_literal: true

require "minitest/autorun"
require "minitest/mock"
require_relative "../../lib/main"
require_relative "helper"

class TrainsManagementTest < Minitest::Test
  include Scenarios

  def setup
    @helper = TestHelper.new
  end

  def test_create_train
    scenario_create_train(train_number: "001-01", type: :passenger, manufacturer: "Golden Wagon")
    scenario_list_train
    scenario_quit

    @helper.run_app

    assert_match(/Passenger train #001-01 is created\n/, @helper.output.string)
    assert_match(/1. Train #001-01, passenger, 0 carriages\n/, @helper.output.string)
  end

  def test_show_train
    scenario_create_train(train_number: "001-01", type: :passenger, manufacturer: "Golden Wagon")
    scenario_show_train
    scenario_quit

    @helper.run_app

    expected = /Passenger train #001-01 is at the factory Golden Wagon\nNo carriages\n/

    assert_match(expected, @helper.output.string)
  end
end
