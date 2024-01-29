# frozen_string_literal: true

require_relative '../model/station'

# rubocop:disable Style/Documentation
class StationController
  def initialize(storage)
    @storage = storage
  end

  def create_station(name:)
    station = Station.new(name)
    @storage.add_to_list(:stations, station)
    "#{station.to_s.capitalize} is created"
  end

  def list_stations
    stations = @storage.get(:stations, []).map.with_index(1) do |station, index|
      "#{index}. #{station.to_s.capitalize}"
    end
    stations.empty? ? 'No stations' : stations.join('\n')
  end

  def list_trains_on_station(station_index:)
    station = @storage.get(:stations, [])[station_index - 1]
    return nil if station.nil?

    trains = station.trains.map.with_index(1) do |train, index|
      "#{index}. #{train.to_s.capitalize}"
    end
    trains.empty? ? 'No trains' : trains.join('\n')
  end
end
# rubocop:enable all
