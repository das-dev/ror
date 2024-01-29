# frozen_string_literal: true

require_relative '../model/route'

# rubocop:disable Style/Documentation
class RouteController
  def initialize(storage, station_controller)
    @storage = storage
    @station_controller = station_controller
  end

  def create_route
    puts 'Let\'s create an origin station'
    origin = @station_controller.create_station
    puts 'Let\'s create a destination station'
    destination = @station_controller.create_station
    route = Route.new(origin, destination)
    @storage.add_to_list(:routes, route)
    puts "#{route.to_s.capitalize} is created"
    route
  end

  def list_routes
    puts 'Routes:'
    @storage.get(:routes, []).each.with_index(1) do |route, index|
      puts "#{index}. #{route.to_s.capitalize}"
    end.empty? && puts('No routes')
  end

  def select_route
    list_routes
    puts 'Enter route number or type \'c\' to create new:'
    event = gets.chomp
    route = @storage.get(:routes, [])[event.to_i - 1]
    route = create_route if route.nil? && event == 'c'
    route
  end

  def add_intermediate_station
    route = select_route
    return nil if route.nil?

    station = @station_controller.create_station
    route.append_intermediate_station(station)
    puts "#{station} is added to #{route}"
  end

  def remove_intermediate_station
    route = select_route
    return nil if route.nil?

    station = @station_controller.select_station
    route.remove_intermediate_station(station)
    puts "#{station} is removed from #{route}"
  end

  def assign_route_to_train
    train = @train_controller.choose_train
    route = select_route
    return nil if route.nil? || train.nil?

    train.assign_route(route)
    puts "#{train} assigned #{route}"
  end
end
# rubocop:enable all
