# frozen_string_literal: true

require 'stringio'
require 'minitest/autorun'
require 'minitest/mock'
require_relative '../../lib/main'

class UseCasesTest < Minitest::Test
  MAIN_MENU = <<~MAIN_MENU
    Main Menu
    1. Manage Stations
    2. Manage Trains
    3. Manage Routes
    4. Move Trains
    a. About app
    s. Stat
    q. Quit
    Choose an option:
  MAIN_MENU

  def setup
    @input = StringIO.new
    $stdin = @input

    @output = StringIO.new
    $stdout = @output
  end

  def test_main_menu
    scenario_quit

    run_app

    assert_equal MAIN_MENU, @output.string
  end

  def test_create_station
    scenario_create_station(station_name: 'Origin')
    scenario_create_station(station_name: 'Destination')
    scenario_list_station
    scenario_quit

    run_app

    assert_match(/\nStation "origin" is created/, @output.string)
    assert_match(/\n1. Station "origin"/, @output.string)

    assert_match(/\nStation "destination" is created/, @output.string)
    assert_match(/\n2. Station "destination"/, @output.string)
  end

  def test_create_route
    scenario_create_station(station_name: 'Origin')
    scenario_create_station(station_name: 'Destination')
    scenario_create_route
    scenario_routes_list
    scenario_quit

    run_app

    assert_match(/\nRoute: origin -> destination is created/, @output.string)
    assert_match(/\n1. Route: origin -> destination/, @output.string)
  end

  private

  def run_app
    app = Application.new
    navigation = app.instance_variable_get(:@navigation)
    navigation.define_singleton_method(:clear_screen) { nil }
    app.run
    restore_standard_input_output
  end

  def restore_standard_input_output
    $stdin = STDIN
    $stdout = STDOUT
  end

  def scenario_create_station(station_name:)
    ['0', '1', '1', station_name, ''].each do |input|
      @input.puts(input)
    end
  end

  def scenario_list_station
    ['0', '1', '2', ''].each do |input|
      @input.puts(input)
    end
  end

  def scenario_create_route
    ['0', '3', '1', '1', '2', ''].each do |input|
      @input.puts(input)
    end
  end

  def scenario_routes_list
    ['0', '3', '2', ''].each do |input|
      @input.puts(input)
    end
  end

  def scenario_quit
    @input.puts 'q'
    @input.rewind
  end
end
