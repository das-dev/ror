# frozen_string_literal: true

# rubocop:disable Style/Documentation
class ManageStations
  def initialize(navigation, station_controller)
    @station_controller = station_controller
    @navigation = navigation
  end

  def make_menu
    manage_stations
    create_station
    list_stations
    list_trains_on_station
  end

  private

  attr_reader :station_controller, :navigation

  def manage_stations
    navigation.make('Manage Stations', :manage_stations) do |menu|
      menu.choice('Create station', :create_station, '1')
      menu.choice('List stations', :list_stations, '2')
      menu.choice('List trains on station', :list_trains_on_station, '3')
      menu.choice 'Back to Main Menu', :main_menu, '0'
    end
  end

  def create_station
    navigation.bind('Create station form', :create_station, station_controller, :manage_stations) do
      puts 'Enter station name:'
      { name: gets.chomp }
    end
  end

  def list_stations
    navigation.bind('List stations:', :list_stations, station_controller, :manage_stations)
  end

  def list_trains_on_station
    navigation.bind('Select station:', :list_trains_on_station, station_controller, :manage_stations) do
      puts station_controller.list_stations
      puts 'Enter # station or press Enter to return to stations menu:'
      { station_index: gets.chomp.to_i }
    end
  end
end
# rubocop:enable all
