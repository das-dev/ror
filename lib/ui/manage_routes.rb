# frozen_string_literal: true

require_relative 'abc_menu'

# rubocop:disable Style/Documentation
class ManageRoutes < AbcMenu
  def make_menu
    manage_routes
    create_route
    list_routes
    add_intermediate_station
    remove_intermediate_station
  end

  private

  # приватные потому что нужен единообразный интерфейс (метод make_menu)
  def manage_routes
    navigation.make('Manage Routes', :manage_routes) do |menu|
      menu.choice('Create route', :create_route, '1')
      menu.choice('List routes', :list_routes, '2')
      menu.choice('Add station into a route', :add_station, '3')
      menu.choice('Remove station from a route', :remove_station, '4')
      menu.choice('Back to Main AbcMenu', :main_menu, '0')
      menu.choice('Quit', :exit, 'q')
    end
  end

  def list_routes
    navigation.bind('List routes:', :list_routes, :manage_routes)
  end

  def create_route
    navigation.bind('Create route form', :create_route, :manage_routes) do
      puts navigation.send_action(:list_stations)
      origin_index = choose_origin_station

      puts navigation.send_action(:list_stations)
      destination_index = choose_destination_station

      { origin_index:, destination_index: }
    end
  end

  def add_intermediate_station
    navigation.bind('Add station into a route', :add_station, :manage_routes) do
      puts navigation.send_action(:list_routes)
      route_index = choose_route

      puts navigation.send_action(:list_stations)
      station_index = choose_station

      { route_index:, station_index: }
    end
  end

  def remove_intermediate_station
    navigation.bind('Remove station from a route', :remove_station, :manage_routes) do
      puts navigation.send_action(:list_routes)
      route_index = choose_route

      puts navigation.send_action(:list_stations)
      station_index = choose_station

      { route_index:, station_index: }
    end
  end
end
# rubocop:enable all
