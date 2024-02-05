# frozen_string_literal: true

require 'stringio'

class TestHelper
  attr_reader :input, :output

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

  def initialize
    @input = StringIO.new
    $stdin = @input

    @output = StringIO.new
    $stdout = @output
  end

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
