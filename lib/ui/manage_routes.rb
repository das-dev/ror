# frozen_string_literal: true

# rubocop:disable Style/Documentation
class ManageRoutes
  def initialize(navigation, route_controller)
    @route_controller = route_controller
    @navigation = navigation
  end

  def make_menu
    manage_routes
  end

  private

  attr_reader :route_controller, :navigation

  def manage_routes
    navigation.make('Manage Routes', :manage_routes) do |menu|
      create_route(menu, '1')
      add_intermediate_station(menu, '2')
      remove_intermediate_station(menu, '3')
      list_routes(menu, '4')
      assign_route_to_train(menu, '5')
      menu.choice 'Back to Main Menu', :main_menu, '0'
    end
  end

  def create_route(menu, key)
    menu.choice('Create route', :create_route, key) do
      route_controller.create_route
      :manage_routes
    end
  end

  def add_intermediate_station(menu, key)
    menu.choice('Add station into a route', :add_intermediate_station, key) do
      route_controller.add_intermediate_station
      :manage_routes
    end
  end

  def remove_intermediate_station(menu, key)
    menu.choice('Remove station into a route', :remove_intermediate_station, key) do
      route_controller.remove_intermediate_station
      :manage_routes
    end
  end

  def list_routes(menu, key)
    menu.choice('List routes', :list_routes, key) do
      route_controller.list_routes
      :manage_routes
    end
  end

  def assign_route_to_train(menu, key)
    menu.choice('Set route to train', :set_route_to_train, key) do
      route_controller.assign_route_to_train
      :manage_routes
    end
  end
end
# rubocop:enable all
