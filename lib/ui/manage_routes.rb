# frozen_string_literal: true

# rubocop:disable Style/Documentation
class ManageRoutes
  def initialize(navigation, route_controller)
    @route_controller = route_controller
    @navigation = navigation
  end

  def make_menu
    manage_routes
    create_route
    list_routes
    add_intermediate_station
    remove_intermediate_station
  end

  private

  attr_reader :route_controller, :navigation

  def manage_routes
    navigation.make('Manage Routes', :manage_routes) do |menu|
      menu.choice('Create route', :create_route, '1')
      menu.choice('List routes', :list_routes, '2')
      menu.choice('Add station into a route', :add_intermediate_station, '3')
      menu.choice('Remove station from a route', :remove_intermediate_station, '4')
      menu.choice 'Back to Main Menu', :main_menu, '0'
    end
  end

  def list_routes
    navigation.bind('List routes:', :list_routes, route_controller, :manage_routes)
  end

  def create_route
    navigation.bind('Create route form', :create_route, route_controller, :manage_routes) do
      puts 'Enter an origin station name:'
      origin = station_controller.create_station(gets.chomp)

      puts 'Enter a destination station name:'
      destination = station_controller.create_station(gets.chomp)

      { origin:, destination: }
    end
  end

  def add_intermediate_station
    navigation.bind('Add station into a route', :add_intermediate_station, route_controller, :manage_routes) do
      puts route_controller.list_routes
      puts 'Enter route number:'
      route_index = gets.chomp

      puts station_controller.list_stations
      puts 'Enter station number:'
      station_index = gets.chomp

      { route_index:, station_index: }
    end
  end

  def remove_intermediate_station
    navigation.bind('Remove station from a route', :remove_intermediate_station, route_controller, :manage_routes) do
      puts route_controller.list_routes
      puts 'Enter route number:'
      route_index = gets.chomp

      puts station_controller.list_stations
      puts 'Enter station number:'
      station_index = gets.chomp

      { route_index:, station_index: }
    end
  end
end
# rubocop:enable all
