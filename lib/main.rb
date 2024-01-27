# frozen_string_literal: true

require_relative 'ui/navigation'
require_relative 'ui/station_controller'

stations = StationController.new

nav = Navigation.new
nav.make('Main Menu', :main_menu) do |main_menu|
  main_menu.choice('Create station', :create_station, '1') do
    stations.create_station
    :main_menu
  end
  main_menu.choice('List stations', :list_station, '2') do
    stations.list_station
    :main_menu
  end
  main_menu.choice 'Exit', :exit, '3'
end

until nav.exit?
  event = nav.prompt
  nav.process(event)
end
