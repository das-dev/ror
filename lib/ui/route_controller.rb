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
    puts "Route #{route.origin_station.name} - #{route.destination_station.name} created"
  end

  def list_routes
    puts 'Routes:'
    p @storage.get(:trains, [])
    @storage.get(:routes, []).each_with_index do |route, index|
      puts "#{index + 1}. Route from \"#{route.origin_station.name}\" to \"#{route.destination_station.name}\""
    end
  end

  def select_route
    puts 'Select route:'
    list_routes
    index = gets.chomp.to_i - 1
    @storage.get(:routes, [])[index]
  end

  def add_intermediate_station
    route = select_route
    station = @station_controller.create_station
    route.append_intermediate_station(station)
    puts "Station #{station.name} added to route #{route.origin_station.name} - #{route.destination_station.name}"
  end
end
# rubocop:enable all
