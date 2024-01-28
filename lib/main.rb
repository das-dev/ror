# frozen_string_literal: true

require_relative 'storage/key_value_storage'
require_relative 'ui/navigation'
require_relative 'ui/station_controller'
require_relative 'ui/train_controller'
require_relative 'ui/route_controller'

storage = KeyValueStorage.new

station_controller = StationController.new(storage)
train_controller = TrainController.new(storage)
route_controller = RouteController.new(storage, station_controller)

nav = Navigation.new
nav.make('Main Menu', :main_menu) do |main_menu|
  main_menu.choice('Create station', :create_station, '1') do
    station_controller.create_station
    :main_menu
  end
  main_menu.choice('List stations', :list_station, '2') do
    station_controller.list_station
    :main_menu
  end
  main_menu.choice('Create train', :create_train, '3') do
    train_controller.create_train
    :main_menu
  end
  main_menu.choice('List trains', :list_trains, '4') do
    train_controller.list_trains
    :main_menu
  end
  main_menu.choice('Create route', :create_route, '5') do
    route_controller.create_route
    :main_menu
  end
  main_menu.choice('Add station into a route', :add_intermediate_station, '6') do
    route_controller.add_intermediate_station
    :main_menu
  end
  main_menu.choice('List routes', :list_routes, '7') do
    route_controller.list_routes
    :main_menu
  end
  main_menu.choice 'Quit', :exit, 'q'
end

until nav.exit?
  nav.display
  nav.process(gets.chomp)
end
