# frozen_string_literal: true

require_relative '../model/station'

# rubocop:disable Style/Documentation
class StationController
  def create_station(name:)
    return 'Station is not created: name is empty' if name.empty?

    station = Station.new(name)
    "#{station.to_s.capitalize} is created"
  end

  def list_stations
    stations = Station.all.map.with_index(1) do |station, index|
      "#{index}. #{station.to_s.capitalize}"
    end
    stations.empty? ? 'No stations' : stations.join("\n")
  end

  def list_trains_on_station(station_index:)
    station = get_station(station_index.to_i)
    return 'Station not found' unless station

    trains = station.trains.map.with_index(1) do |train, index|
      "#{index}. #{train.to_s.capitalize}"
    end
    trains.empty? ? 'No trains on station' : trains.join("\n")
  end

  private

  # приватные хелперы

  def get_station(station_index)
    station = Station.all[station_index - 1]
    station_index.positive? && station
  end
end
# rubocop:enable all
