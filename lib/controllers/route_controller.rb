# frozen_string_literal: true

require_relative '../model/route'

# rubocop:disable Style/Documentation
class RouteController
  def initialize(storage)
    @storage = storage
  end

  def create_route(origin_index:, destination_index:)
    origin = get_station(origin_index.to_i)
    return 'Origin station not found' unless origin

    destination = get_station(destination_index.to_i)
    return 'Destination station not found' unless destination

    return 'Origin and destination stations are the same' if origin == destination

    route = Route.new(origin, destination)
    @storage.add_to_list(:routes, route)
    "#{route.to_s.capitalize} is created"
  end

  def list_routes
    routes = @storage.get(:routes, []).map.with_index(1) do |route, index|
      "#{index}. #{route.to_s.capitalize}"
    end
    routes.empty? ? 'No routes' : routes.join("\n")
  end

  def add_intermediate_station(route_index:, station_index:)
    route = get_route(route_index.to_i)
    return 'Route not found' unless route

    station = get_station(station_index.to_i)
    return 'Station not found' unless station
    return 'Station is already in the route' if route.stations.include?(station)

    route.append_intermediate_station(station)
    "#{station.to_s.capitalize} is added to #{route}"
  end

  def remove_intermediate_station(route_index:, station_index:)
    route = get_route(route_index.to_i)
    return 'Route not found' unless route

    station = get_station(station_index.to_i)
    return 'Station not found' unless station
    return 'Station is not in the route' unless route.stations.include?(station)
    return 'Cannot remove an origin station' if route.origin_station == station
    return 'Cannot remove a destination station' if route.destination_station == station

    route.remove_intermediate_station(station)
    "#{station.to_s.capitalize} is removed from #{route}"
  end

  private

  def get_route(route_index)
    route = @storage.get(:routes, [])[route_index - 1]
    route_index.positive? && route
  end

  def get_station(station_index)
    station = @storage.get(:stations, [])[station_index - 1]
    station_index.positive? && station
  end
end
# rubocop:enable all
