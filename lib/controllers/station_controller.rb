# frozen_string_literal: true

require_relative '../model/station'
require_relative 'exceptions'

# rubocop:disable Style/Documentation
class StationController
  def initialize(storage)
    @storage = storage
  end

  def create_station(name:)
    station = try_to_create_station(name)
    @storage.add_to_list(:stations, station)
    "#{station.titlecase} is created"
  end

  def list_stations
    stations = @storage.get(:stations, []).map.with_index(1) do |station, index|
      "#{index}. #{station.titlecase}"
    end
    stations.empty? ? 'No stations' : stations.join("\n")
  end

  def list_trains_on_station(station_index:)
    station = get_station(station_index)
    trains = station.trains.map.with_index(1) do |train, index|
      "#{index}. #{train.titlecase}"
    end
    trains.empty? ? 'No trains on station' : trains.join("\n")
  end

  private

  # приватные хелперы

  def try_to_create_station(name)
    Station.new(name)
  rescue ValidationError => e
    raise ControllerError, "Station is not created: #{e.message}"
  end

  def get_station(station_index)
    station = @storage.get(:stations, [])[station_index.to_i - 1]
    raise ControllerError, "Station ##{station_index} not found" unless station && station_index.to_i.positive?

    station
  end
end
# rubocop:enable all
