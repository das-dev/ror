# frozen_string_literal: true

# rubocop:disable Style/Documentation
class ManageStations
  def initialize(navigation, station_controller)
    @station_controller = station_controller
    @navigation = navigation
  end

  def make_menu
    manage_stations
  end

  private

  attr_reader :station_controller, :navigation

  def manage_stations
    navigation.make('Manage Stations', :manage_stations) do |menu|
      create_station(menu, '1')
      list_stations(menu, '2')
      list_trains_on_station(menu, '3')
      menu.choice 'Back to Main Menu', :main_menu, '0'
    end
  end

  def create_station(menu, key)
    menu.choice('Create station', :create_station, key) do
      station_controller.create_station
      :manage_stations
    end
  end

  def list_stations(menu, key)
    menu.choice('List stations', :list_stations, key) do
      station_controller.list_stations
      :manage_stations
    end
  end

  def list_trains_on_station(menu, key)
    menu.choice('List trains on station', :list_trains_on_station, key) do
      station_controller.list_trains_on_station
      :manage_stations
    end
  end
end
# rubocop:enable all
