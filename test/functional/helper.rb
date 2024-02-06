# frozen_string_literal: true

require 'stringio'

class TestHelper
  attr_reader :input, :output

  MAIN_MENU = <<~MAIN_MENU
    Main Menu
    1. Manage Stations
    2. Manage Carriages
    3. Manage Trains
    4. Manage Routes
    5. Move Trains
    a. About app
    s. Stat
    q. Quit
    Choose an option:
  MAIN_MENU

  STAT_VIEW = <<~STAT_VIEW
    Stations: %d
    Cargo carriages: %d
    Passenger carriages: %d
    Cargo trains: %d
    Passenger trains: %d
    Routes: %d
  STAT_VIEW

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
end

module Scenarios
  def scenario_stat
    ['0', 's', ''].each do |input|
      @helper.input.puts(input)
    end
  end

  def scenario_create_station(station_name:)
    ['0', '1', '1', station_name, ''].each do |input|
      @helper.input.puts(input)
    end
  end

  def scenario_list_station
    ['0', '1', '2', ''].each do |input|
      @helper.input.puts(input)
    end
  end

  def scenario_create_train(train_number:, type:, manufacturer:)
    train_type = { passenger: '1', cargo: '2' }[type]
    ['0', '3', '1', train_number, train_type, manufacturer, ''].each do |input|
      @helper.input.puts(input)
    end
  end

  def scenario_list_train
    ['0', '3', '2', ''].each do |input|
      @helper.input.puts(input)
    end
  end

  def scenario_show_train
    ['0', '3', '3', '1', ''].each do |input|
      @helper.input.puts(input)
    end
  end

  def scenario_create_carriage(carriage_number:, type:, manufacturer:)
    carriage_type = { passenger: '1', cargo: '2' }[type]
    ['0', '2', '1', carriage_number, carriage_type, manufacturer, ''].each do |input|
      @helper.input.puts(input)
    end
  end

  def scenario_add_carriage(train_index:, carriage_index:)
    ['0', '2', '4', train_index, carriage_index, ''].each do |input|
      @helper.input.puts(input)
    end
  end

  def scenario_create_route
    ['0', '4', '1', '1', '2', ''].each do |input|
      @helper.input.puts(input)
    end
  end

  def scenario_routes_list
    ['0', '4', '2', ''].each do |input|
      @helper.input.puts(input)
    end
  end

  def scenario_quit
    @helper.input.puts 'q'
    @helper.input.rewind
  end
end
