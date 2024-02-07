# frozen_string_literal: true

require_relative 'abc_menu'

# rubocop:disable Style/Documentation
class ManageStations < AbcMenu
  def make_menu
    manage_stations
    create_station
    list_stations
    list_trains_on_station
  end

  private

  # приватные потому что нужен единообразный интерфейс (метод make_menu)
  def manage_stations
    navigation.make('Manage Stations', :manage_stations) do |menu|
      menu.choice('Create station', :create_station, '1')
      menu.choice('List stations', :list_stations, '2')
      menu.choice('List trains on station', :list_trains_on_station, '3')
      menu.choice('Back to Main Menu', :main_menu, '0')
      menu.choice('Quit', :exit, 'q')
    end
  end

  def create_station
    navigation.bind('Create station form', :create_station, :manage_stations, attempts: 3) do
      name = enter_station_name

      { name: }
    end
  end

  def list_stations
    navigation.bind('List stations:', :list_stations, :manage_stations)
  end

  def list_trains_on_station
    navigation.bind('Select station:', :list_trains_on_station, :manage_stations) do
      puts navigation.send_action(:list_stations)
      station_index = choose_station
      { station_index: }
    end
  end
end
# rubocop:enable all
