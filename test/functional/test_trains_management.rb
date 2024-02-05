# frozen_string_literal: true

require 'minitest/autorun'
require 'minitest/mock'
require_relative '../../lib/main'
require_relative 'helper'

class TrainsManagementTest < Minitest::Test
  include Scenarios

  def setup
    @helper = TestHelper.new
    @input = @helper.input
    @output = @helper.output
  end

  def test_create_train
    scenario_create_train(train_number: '001-01', type: :passenger, manufacturer: 'GoldenWagon')
    scenario_list_train
    scenario_quit

    @helper.run_app

    assert_match(/Passenger train #001-01 is created\n/, @output.string)
    assert_match(/1. Passenger train #001-01\n/, @output.string)
  end

  def test_show_train
    scenario_create_train(train_number: '001-01', type: :passenger, manufacturer: 'GoldenWagon')
    scenario_show_train
    scenario_quit

    @helper.run_app

    expected = /Passenger train #001-01 is at the factory GoldenWagon\nwith 0 carriages\n/
    assert_match(expected, @output.string)
  end

  def test_add_carriage
    scenario_create_train(train_number: '001-01', type: :passenger, manufacturer: 'GoldenWagon')
    scenario_add_carriage(carriage_number: '100')
    scenario_show_train
    scenario_quit

    @helper.run_app

    expected = /Passenger train #001-01 is at the factory GoldenWagon\nwith 1 carriages\n/
    assert_match(expected, @output.string)

    assert_match(/Carriage #100 is attached to passenger train #001-01\n/, @output.string)
  end
end
