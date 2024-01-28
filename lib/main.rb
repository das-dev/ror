# frozen_string_literal: true

require_relative 'storage/key_value_storage'
require_relative 'ui/navigation'
require_relative 'ui/station_controller'
require_relative 'ui/train_controller'
require_relative 'ui/route_controller'

# rubocop:disable Style/Documentation
class Application
  attr_reader :station_controller, :train_controller, :route_controller, :navigation

  def initialize
    @storage = KeyValueStorage.new

    @station_controller = StationController.new(@storage)
    @train_controller = TrainController.new(@storage)
    @route_controller = RouteController.new(@storage, @station_controller)

    @navigation = Navigation.new
  end

  def run
    make_menu
    until navigation.exit?
      navigation.display
      navigation.process(gets.chomp)
    end
  end

  private

  def make_menu
    navigation.make('Main Menu', :main_menu) do |main_menu|
      create_station(main_menu)
      list_stations(main_menu)
      create_train(main_menu)
      list_trains(main_menu)
      create_route(main_menu)
      add_station(main_menu)
      list_routes(main_menu)
      main_menu.choice 'Quit', :exit, 'q'
    end
  end

  def create_station(menu)
    menu.choice('Create station', :create_station, '1') do
      station_controller.create_station
      :main_menu
    end
  end

  def list_stations(menu)
    menu.choice('List stations', :list_stations, '2') do
      station_controller.list_stations
      :main_menu
    end
  end

  def create_train(menu)
    menu.choice('Create train', :create_train, '3') do
      train_controller.create_train
      :main_menu
    end
  end

  def list_trains(menu)
    menu.choice('List trains', :list_trains, '4') do
      train_controller.list_trains
      :main_menu
    end
  end

  def create_route(menu)
    menu.choice('Create route', :create_route, '5') do
      route_controller.create_route
      :main_menu
    end
  end

  def add_station(menu)
    menu.choice('Add station into a route', :add_intermediate_station, '6') do
      route_controller.add_intermediate_station
      :main_menu
    end
  end

  def list_routes(menu)
    menu.choice('List routes', :list_routes, '7') do
      route_controller.list_routes
      :main_menu
    end
  end
end
# rubocop:enable all

Application.new.run if $PROGRAM_NAME == __FILE__
