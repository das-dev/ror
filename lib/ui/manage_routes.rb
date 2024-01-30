# frozen_string_literal: true

# rubocop:disable Style/Documentation
class ManageRoutes
  def initialize(navigation)
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
    navigation.bind('List routes:', :list_routes, :manage_routes)
  end

  def create_route
    navigation.bind('Create route form', :create_route, :manage_routes) do
      puts 'Enter an origin station name:'
      origin = navigation.send_action(:create_station, name: gets.chomp)

      puts 'Enter a destination station name:'
      destination = navigation.send_action(:create_station, name: gets.chomp)

      { origin:, destination: }
    end
  end

  def add_intermediate_station
    navigation.bind('Add station into a route', :add_intermediate_station, :manage_routes) do
      puts navigation.send_action(:list_routes)
      puts 'Enter route number:'
      route_index = gets.chomp

      puts navigation.send_action(:list_stations)
      puts 'Enter station number:'
      station_index = gets.chomp

      { route_index:, station_index: }
    end
  end

  def remove_intermediate_station
    navigation.bind('Remove station from a route', :remove_intermediate_station, :manage_routes) do
      puts navigation.send_action(:list_routes)
      puts 'Enter route number:'
      route_index = gets.chomp

      puts navigation.send_action(:list_stations)
      puts 'Enter station number:'
      station_index = gets.chomp

      { route_index:, station_index: }
    end
  end
end
# rubocop:enable all
