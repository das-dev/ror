# frozen_string_literal: true

require_relative '../model/route'
require_relative 'exceptions'

# rubocop:disable Style/Documentation
class RouteController
  def initialize(storage)
    @storage = storage
  end

  def create_route(origin_index:, destination_index:)
    origin = get_station(origin_index)
    destination = get_station(destination_index)

    route = try_to_create_route(origin, destination)

    @storage.add_to_list(:routes, route)
    "#{route.titlecase} is created"
  end

  def list_routes
    routes = @storage.get(:routes, []).map.with_index(1) do |route, index|
      "#{index}. #{route.titlecase}"
    end
    routes.empty? ? 'No routes' : routes * "\n"
  end

  def add_intermediate_station(route_index:, station_index:)
    route = get_route(route_index)
    station = get_station(station_index)
    raise ControllerError, 'Station is already in the route' if route.stations.include?(station)

    route.append_intermediate_station(station)
    "#{station.titlecase} is added to #{route}"
  end

  def remove_intermediate_station(route_index:, station_index:)
    route = get_route(route_index)

    station = get_station(station_index)
    raise ControllerError, 'Station is not in the route' unless route.stations.include?(station)
    raise ControllerError, 'Cannot remove an origin station' if route.origin_station == station
    raise ControllerError, 'Cannot remove a destination station' if route.destination_station == station

    route.remove_intermediate_station(station)
    "#{station.titlecase} is removed from #{route}"
  end

  private

  # приватные хелперы

  def try_to_create_route(origin, destination)
    Route.new(origin, destination)
  rescue ValidationError => e
    raise ControllerError, "Route is not created: #{e.message}"
  end

  def get_route(route_index)
    route = @storage.get(:routes, [])[route_index.to_i - 1]
    raise ControllerError, "Route ##{route_index} not found" unless route && route_index.to_i.positive?

    route
  end

  def get_station(station_index)
    station = @storage.get(:stations, [])[station_index.to_i - 1]
    raise ControllerError, "Station ##{station_index} not found" unless station && station_index.to_i.positive?

    station
  end
end
# rubocop:enable all
